class BenchmarkExecution < ActiveRecord::Base
  belongs_to :benchmark_definition
  validates :benchmark_definition, presence: true
  has_many :virtual_machine_instances, dependent: :destroy
  has_many :events, as: :traceable, dependent: :destroy do
    include EventsAsTraceableExtension
  end

  PROVIDER = 'aws'
  PRIORITY_HIGH = 1

  def active?
    # Executions without id may just be built from a view (e.g. start execution button) and does not really exist
    id.present? && !has_event_with_name?(:finished_releasing_resources) && !has_event_with_name?(:failed_on_releasing_resources)
  end

  def inactive?
    !active?
  end

  def benchmark_duration
    if active? && benchmark_started?
      Time.current - benchmark_start_time
    elsif inactive? && benchmark_started?
      benchmark_end_time - benchmark_start_time
    else
      nil
    end
  end

  def execution_duration
    if active?
      Time.current - execution_start_time
    else
      execution_end_time - execution_start_time
    end
  end

  def failed?
    events.any_failed?
  end

  def status
    events.status_from_history
  end

  def has_event_with_name?(name)
    events.first_with_name(name).present?
  end

  def time_of_first_event_with_name(name)
    first = events.first_with_name(name)
    first.present? ? first.happened_at : nil
  end

  def benchmark_start_time
    time_of_first_event_with_name(:started_running)
  end

  def benchmark_started?
    has_event_with_name?(:started_running)
  end

  def benchmark_end_time
    time_of_first_event_with_name(:finished_running)
  end

  def benchmark_active?
    has_event_with_name?(:finished_running)
  end

  def execution_start_time
    time_of_first_event_with_name(:created)
  end

  def execution_started?
    has_event_with_name?(:created)
  end

  def execution_end_time
    time_of_first_event_with_name(:finished_releasing_resources) || time_of_first_event_with_name(:failed_on_releasing_resources)
  end

  def finished?
    has_event_with_name?(:finished_releasing_resources)
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
    # TODO: Handle vagrant up failure appropriately!!! Throw and catch (here) app specific error.
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id), PRIORITY_HIGH, 15.minutes.from_now) if Rails.env.production?
  end

  def detect_and_create_vm_instances_with(driver)
    vm_instances = driver.detect_vm_instances
    vm_instances.each do |vm|
      self.virtual_machine_instances.create(status: self.status,
                                            provider_name: vm[:provider_name],
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
    # TODO: Think about is_alive timeout.
  rescue => e
    # TODO: Handle vagrant ssh failure appropriately!!! Throw and catch (here) app specific error.
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id), PRIORITY_HIGH, 15.minutes.from_now) if Rails.env.production?
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
    # TODO: Handle vagrant ssh failure appropriately!!! Throw and catch (here) app specific error.
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id), PRIORITY_HIGH, 15.minutes.from_now) if Rails.env.production?
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
    release_resources_with(@driver)
  rescue => e
    # TODO: Handle vagrant ssh failure appropriately!!! Throw and catch (here) app specific error.
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id), PRIORITY_HIGH, 15.minutes.from_now) if Rails.env.production?
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
