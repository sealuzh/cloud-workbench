class BenchmarkExecution < ActiveRecord::Base
  belongs_to :benchmark_definition
  validates :benchmark_definition, presence: true
  has_many :virtual_machine_instances
  before_destroy :remove_vagrant_dir
  PRIORITY_HIGH = 1

  def active?
    # TODO: Implement based on new state model using symbolic values (enum) or based on end_time
    status != 'FINISHED'
  end

  def inactive?
    !active?
  end

  def duration
    if active?
      Time.current - start_time
    else
      end_time - start_time
    end
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
    # Update status
    self.status = 'PREPARING'
    self.start_time = Time.current
    self.save!

    provider = 'aws'
    success = driver.up(provider)
    if success
      # Update status
      self.status = 'WAITING FOR RUN'
      save!
    else
      # Update status
      self.status = 'FAILED ON PREPARING'
      save!
      fail status
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
      # Status update
      benchmark_end_time = Time.current
      self.status = 'RUNNING'
      save!
    else
      # Status update
      self.status = 'FAILED ON START BENCHMARK'
      save!
      fail status
    end
  end

  def start_postprocessing
    set_benchmark_runner_and_fs
    start_benchmark_with(@benchmark_runner)
  rescue => e
    # TODO: Handle vagrant ssh failure appropriately!!! Throw and catch (here) app specific error.
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id), PRIORITY_HIGH, 15.minutes.from_now) if Rails.env.production?
  end

  def start_postprocessing_with(benchmark_runner)
    success = benchmark_runner.start_postprocessing
    if success
      # Status update
      self.status = 'POSTPROCESSING'
      save!
    else
      # Status update
      self.status = 'FAILED ON START POSTPROCESSING'
      save!
      fail status
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
    # Update status
    self.status = 'RELEASING_RESOURCES'
    save!

    success = driver.destroy

    if success
      # Update status
      end_time = Time.current
      self.status = 'FINISHED'
      save!
    else
      self.status = 'FAILED ON RELEASING RESOURCES'
      save!
      fail status
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
