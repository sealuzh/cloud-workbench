class BenchmarkExecution < ActiveRecord::Base
  PROVIDER = 'aws'
  PRIORITY_HIGH = 1
  belongs_to :benchmark_definition
  validates :benchmark_definition, presence: true
  has_many :virtual_machine_instances, dependent: :destroy
  has_many :events, as: :traceable, dependent: :destroy do
    include EventsAsTraceableExtension
  end
  include EventStatusHelper

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
    Delayed::Job.enqueue(StartBenchmarkExecutionJob.new(id), PRIORITY_HIGH)
  rescue => e
    timeout = Rails.application.config.failure_timeout
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id), PRIORITY_HIGH, timeout.minutes.from_now) if Rails.env.production?
  end

  def detect_and_create_vm_instances_with(driver)
    vm_instances = driver.detect_vm_instances
    vm_instances.each do |vm|
      self.virtual_machine_instances.create(provider_name: vm[:provider_name],
                                            provider_instance_id: vm[:provider_instance_id],
                                            role: vm[:role])
    end
  end

  def prepare_with(driver)
    events.create_with_name!(:started_preparing)
    success = driver.up(PROVIDER)
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

  def start_benchmark
    set_benchmark_runner_and_fs
    start_benchmark_with(@benchmark_runner)
    timeout = benchmark_definition.running_timeout || Rails.application.config.default_running_timeout
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id), PRIORITY_HIGH, timeout.hours.from_now) if Rails.env.production?
  rescue => e
    timeout = Rails.application.config.failure_timeout
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id), PRIORITY_HIGH, timeout.minutes.from_now) if Rails.env.production?
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
    timeout = Rails.application.config.failure_timeout
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id), PRIORITY_HIGH, timeout.minutes.from_now) if Rails.env.production?
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
    release_resources_with(@driver) if active?
  rescue => e
    timeout = Rails.application.config.failure_timeout
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id), PRIORITY_HIGH, timeout.minutes.from_now) if Rails.env.production?
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
