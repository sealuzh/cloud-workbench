class BenchmarkExecution < ActiveRecord::Base
  belongs_to :benchmark_definition
  validates :benchmark_definition, presence: true
  has_many :virtual_machine_instances
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

  def prepare
    prepare_vagrantfile_for_driver
    vagrant_driver = VagrantDriver(vagrantfile_path)
    prepare_with(vagrant_driver)
    vm_instances = vagrant_driver.detect_vm_instances
    vm_instances.each do |vm|
      virtual_machine_instances.create(status: self.status,
                                       provider_name: vm[:provider_name],
                                       provider_instance_id: vm[:provider_instance_id] )
    end

    # Schedule StartBenchmarkExecutionJobs with higher priority than PrepareBenchmarkExecutionJobs.
    # Also consider using multiple queues since long running prepare tasks should not block short running start commands.
    Delayed::Job.enqueue(StartBenchmarkExecutionJob.new(id), PRIORITY_HIGH)
  rescue => e
    # TODO: Handle vagrant up failure appropriately!!! Throw and catch (here) app specific error.
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id)) if Rails.env.production?
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

  def start_benchmark
    vagrant_runner = VagrantRunner(vagrant_dir)
    start_benchmark_with(vagrant_runner)
    # TODO: Think about is_alive timeout.
  rescue => e
    # TODO: Handle vagrant ssh failure appropriately!!! Throw and catch (here) app specific error.
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id)) if Rails.env.production?
  end

  def start_benchmark_with(benchmark_runner)
    # Status update
    status = 'RUNNING'
    benchmark_start_time = Time.current
    save!

    success = benchmark_runner.start_benchmark

    if success
      # Status update
      benchmark_end_time = Time.current
      status = 'WAITING FOR POSTPROCESSING'
      save!
    else
      # Status update
      status = 'FAILED ON START BENCHMARK'
      save!
      fail status
    end
  end

  def start_postprocessing
    vagrant_runner = VagrantRunner(vagrant_dir)
    start_benchmark_with(vagrant_runner)
  rescue => e
    # TODO: Handle vagrant ssh failure appropriately!!! Throw and catch (here) app specific error.
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id)) if Rails.env.production?
  end

  def start_postprocessing_with(benchmark_runner)
    # Status update
    status = 'POSTPROCESSING'
    save!

    success = benchmark_runner.start_postprocessing

    if success
      # Status update
      status = 'WAITING FOR RELEASE RESOURCES'
      save!
    else
      # Status update
      status = 'FAILED ON START POSTPROCESSING'
      save!
      fail status
    end
  end

  def release_resources
    vagrant_driver = VagrantDriver(vagrantfile_path)
    release_resources_with(vagrant_driver)
  rescue => e
    # TODO: Handle vagrant ssh failure appropriately!!! Throw and catch (here) app specific error.
    Delayed::Job.enqueue(ReleaseResourcesJob.new(id)) if Rails.env.production?
  end

  def release_resources_with(driver)
    # Update status
    status = 'RELEASING_RESOURCES'
    save!

    success = driver.destroy

    if success
      # Update status
      end_time = Time.current
      status = 'FINISHED'
      save!
    else
      status = 'FAILED ON RELEASING RESOURCES'
      save!
      fail status
    end
  end

  private

    # Reuse in driver
    # TODO: Move into own module that requires
    # * benchmark_execution_id
    # * benchmark_definition_id
    # * benchmark_definition_name
    # * benchmark_definition_vagrantfile
    def prepare_vagrantfile_for_driver
      create_directory_structure
      write_vagrantfile_to_filesystem
    end

    def create_directory_structure
      FileUtils.mkdir_p(root_dir)
       FileUtils.mkdir_p(vagrant_dir)
       FileUtils.mkdir_p(log_dir)
    end

    def write_vagrantfile_to_filesystem
      vagrantfile = benchmark_definition.vagrantfile
      File.open(vagrantfile_path, 'w') do |file|
        file.write(vagrantfile)
      end
    end

    def benchmark_definition_dir
      File.join(Rails.application.config.benchmark_executions, benchmark_definition_dir_name, root_dir)
    end

    def benchmark_definition_dir_name
      aligned_id = self.benchmark_definition_id.to_s.rjust(3, '0')
      benchmark_definition_name = sanitize_dir_name(benchmark_definition.name)
      "#{aligned_id}-#{benchmark_definition_name}"
    end

    def sanitize_dir_name(name)
      name.gsub(/[^0-9A-z]/, '_')
    end

    def root_dir
      aligned_id = self.id.to_s.rjust(4, '0')
    end

    def vagrant_dir
      File.join(root_dir, 'vagrant')
    end

    def vagrantfile_path
      File.join(vagrant_dir, 'Vagrantfile')
    end

    def log_dir
      File.join(root_dir, 'log')
    end
end
