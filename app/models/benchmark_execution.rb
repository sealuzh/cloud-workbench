# frozen_string_literal: true

class BenchmarkExecution < ApplicationRecord
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
  scope :by_status, lambda { |status|
     case status
     when 'FAILED'
       select { |e| e.failed? }
     else
       select { |e| e.status == status }
     end
   }

  def self.actives
    select { |execution| execution.active? }
  end

  after_initialize do |new_execution|
    @file_system ||= VagrantFileSystem.new(new_execution.benchmark_definition, new_execution)
    @driver ||= VagrantDriver.new(@file_system.vagrantfile_path, @file_system.log_dir)
    @benchmark_runner ||= VagrantRunner.new(@file_system.vagrant_dir)
  end

  def prepare
    @file_system.prepare_vagrantfile_for_driver
    prepare_with(@driver)
    detect_and_create_vm_instances_with(@driver)

    # Schedule StartBenchmarkExecutionJobs with higher priority than PrepareBenchmarkExecutionJobs.
    # Also consider using multiple queues since long running prepare tasks should not block short running start commands.
    # Usually the start execution job can be executed immediately here!
    Delayed::Job.enqueue(StartBenchmarkExecutionJob.new(id), priority: PRIORITY_HIGH)
  rescue => e
    puts e.message
    shutdown_after_failure_timeout
    detect_and_create_vm_instances_with(@driver) rescue nil
  end

  def shutdown_after_failure_timeout
    shutdown_after(Rails.application.config.failure_timeout)
  end

  def shutdown_after(timeout)
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id), priority: PRIORITY_HIGH, run_at: timeout.from_now)
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
    @driver.up_log
  end

  def reprovision
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
    start_benchmark_with(@benchmark_runner)
    timeout_hours = benchmark_definition.running_timeout || Rails.application.config.default_running_timeout
    shutdown_after(timeout_hours.hours)
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
    check_and_log_running_timeout
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

  # This is a heurestic to detect whether the `release_resources` was triggered
  # by an elapsed running time. It avoids duplicating failed on running events.
  # The release resources job would need to store metadata about the reason to
  # release resources (e.g., running timeout) in order to clearly identify this.
  def check_and_log_running_timeout
    if benchmark_active? && !events.last.failed?
      events.create_with_name!(:failed_on_running, 'Running timeout elapsed.')
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
end
