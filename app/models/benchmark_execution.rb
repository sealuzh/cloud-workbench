class BenchmarkExecution < ActiveRecord::Base
  DEFAULT_PROVIDER = Rails.application.config.supported_providers.first
  PRIORITY_HIGH = 1
  belongs_to :benchmark_definition
  validates :benchmark_definition, presence: true
  has_many :virtual_machine_instances, dependent: :destroy
  has_many :events, as: :traceable, dependent: :destroy do
    include EventsAsTraceableExtension
  end
  include EventStatusHelper
  default_scope { order('created_at DESC') }

  def self.actives
    select { |execution| execution.active? }
  end

  # TODO: Consider using the following method signature:
  # + clearer dependencies
  # + testable
  # def prepare(file_system = default_file_system,
  #     driver = default_driver)
  def prepare
    set_driver_and_fs
    @file_system.prepare_vagrantfile_for_driver
    prepare_with(@driver)
    detect_and_create_vm_instances_with(@driver)

    # Schedule StartBenchmarkExecutionJobs with higher priority than PrepareBenchmarkExecutionJobs.
    # Also consider using multiple queues since long running prepare tasks should not block short running start commands.
    # Usually the start execution job can be executed immediately here!
    Delayed::Job.enqueue(StartBenchmarkExecutionJob.new(id), PRIORITY_HIGH)
  rescue => e
    # TODO: Handle exception appropriately
    puts e.message
    shutdown_after_failure_timeout
    detect_and_create_vm_instances_with(@driver) rescue nil
  end

  def shutdown_after_failure_timeout
    timeout = Rails.application.config.failure_timeout
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id), PRIORITY_HIGH, timeout.from_now) if Rails.env.production?
  end

  def detect_and_create_vm_instances_with(driver)
    vm_instances = driver.detect_vm_instances
    vm_instances.each do |vm|
      # HACK: Quick fix to experimentally support the softlayer provider
      # Problem: CWB currently assumes that there is a way to detect the
      # (Vagrant provider) id from within a VM
      # Workaround: This quick fix uses a self-created id to identify the instance.
      # Implication: Multi-VM benchmarks will show up the same instance id for each VM
      # Future improvement: Must think about a generic VM identification solution in future as
      # one cannot expect that the id used by the Vagrant provider (e.g., instance id for aws)
      # is available within the VM itself (e.g., via metadata query API).
      if vm[:provider_name] == 'softlayer'
        vm[:provider_instance_id] = "cwb-#{self.id}"
      end
      self.virtual_machine_instances.create(provider_name: vm[:provider_name],
                                            provider_instance_id: vm[:provider_instance_id],
                                            role: vm[:role])
    end
  end

  def prepare_with(driver)
    events.create_with_name!(:started_preparing)
    provider = self.benchmark_definition.provider_name || DEFAULT_PROVIDER
    success = driver.up(provider)
    if success
      events.create_with_name!(:finished_preparing)
    else
      event = events.create_with_name!(:failed_on_preparing)
      fail event.name
    end
  end

  def prepare_log
    set_driver_and_fs
    @driver.up_log
  end

  def reprovision
    set_driver_and_fs
    vagrantfile = @file_system.evaluate_vagrantfile
    @file_system.create_vagrantfile(vagrantfile)
    reprovision_with(@driver)
  rescue => e
    shutdown_after_failure_timeout
  end

  def reprovision_with(driver)
    events.create_with_name!(:started_reprovisioning)
    success = driver.reprovision
    if success
      events.create_with_name!(:finished_reprovisioning)
    else
      event = events.create_with_name!(:failed_on_reprovisioning)
      fail event.name
    end
  end

  def start_benchmark
    set_benchmark_runner_and_fs
    start_benchmark_with(@benchmark_runner)
    timeout = benchmark_definition.running_timeout || Rails.application.config.default_running_timeout
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id), PRIORITY_HIGH, timeout.hours.from_now) if Rails.env.production?
  rescue => e
    shutdown_after_failure_timeout
  end

  def start_benchmark_with(benchmark_runner)
    success = benchmark_runner.start_benchmark
    if success
      events.create_with_name!(:started_running)
    else
      event = events.create_with_name!(:failed_on_start_running)
      fail event.name
    end
  end

  def start_postprocessing
    set_benchmark_runner_and_fs
    start_postprocessing_with(@benchmark_runner)
  rescue => e
    shutdown_after_failure_timeout
  end

  def start_postprocessing_with(benchmark_runner)
    success = benchmark_runner.start_postprocessing
    if success
      events.create_with_name!(:started_postprocessing)
    else
      event = events.create_with_name!(:failed_on_start_postprocessing)
      fail event.name
    end
  end

  def release_resources
    set_driver_and_fs
    events.create_with_name!(:failed_on_running, 'Running timeout elapsed.') unless benchmark_finished?
    if active? && !keep_alive?
      release_resources_with(@driver)
      update_consecutive_failure_count(benchmark_definition.benchmark_schedule)
    end
  rescue => e
    shutdown_after_failure_timeout
  ensure
    schedule = benchmark_definition.benchmark_schedule
    if schedule.present? && failed? && failed_threshold_reached?(schedule)
      schedule.deactivate!
    end
  end

  def release_resources_with(driver)
    events.create_with_name!(:started_releasing_resources)
    success = driver.destroy
    if success
      events.create_with_name!(:finished_releasing_resources)
    else
      event = events.create_with_name!(:failed_on_releasing_resources)
      fail event.name
    end
  end

  def release_resources_log
    set_driver_and_fs
    @driver.destroy_log
  end

  def update_consecutive_failure_count(schedule)
    if schedule.present?
      failed? ? schedule.consecutive_failure_count += 1 : schedule.consecutive_failure_count = 0
    end
  end

  def failed_threshold_reached?(schedule)
    times = Rails.application.config.execution_failed_threshold
    # Current execution is included as the counter is updated before
    schedule.consecutive_failure_count > times
end

  private

    def set_file_system
      @file_system ||= VagrantFileSystem.new(self.benchmark_definition, self)
    end

    def set_driver_and_fs
      set_file_system
      @driver ||= VagrantDriver.new(@file_system.vagrantfile_path, @file_system.log_dir)
    end

    def set_benchmark_runner_and_fs
      set_file_system
      @benchmark_runner ||= VagrantRunner.new(@file_system.vagrant_dir)
    end
end
