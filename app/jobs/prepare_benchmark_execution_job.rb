require 'fileutils'
class PrepareBenchmarkExecutionJob < Struct.new(:benchmark_definition_id, :benchmark_execution_id)
  PRIORITY_HIGH = 1
  PROVIDER = 'aws'
  # PROVIDER = 'virtualbox'

  def perform
    puts "Preparing benchmark with id #{benchmark_definition_id}"
    benchmark_definition = BenchmarkDefinition.find(benchmark_definition_id)
    benchmark_execution = BenchmarkExecution.find(benchmark_execution_id)

    benchmark_execution.status = 'PREPARING'
    benchmark_execution.start_time = Time.current
    benchmark_execution.save

    logging_path = "#{benchmark_definition.vagrant_directory_path}/.vagrant/log"
    FileUtils.mkdir_p(logging_path)
    log_file = "#{logging_path}/vagrant_up.log"

    %x( cd "#{benchmark_definition.vagrant_directory_path}" &&
        vagrant up --provider=#{PROVIDER} >>#{log_file} 2>&1 )

    # TODO: Support multiple providers and multiple vm instances per benchmark
    default = "#{benchmark_definition.vagrant_directory_path}/.vagrant/machines/default"
    #Dir.entries(machines) # Maybe useful for multi provider support
    provider_name = 'aws'
    provider_instance_id_file = File.join(default, provider_name, 'id')
    provider_instance_id = File.read(provider_instance_id_file)
    benchmark_execution.virtual_machine_instances.create(status: benchmark_execution.status, provider_name: provider_name, provider_instance_id: provider_instance_id)

    if $?.success?
      # TODO: Set StateTransitions for each VirtualMachineInstance
      benchmark_execution.status = 'WAITING FOR RUN'

      # Schedule StartBenchmarkExecutionJobs with higher priority than PrepareBenchmarkExecutionJobs.
      # Also consider using multiple queues since long running prepare tasks should not block short running start commands.
      Delayed::Job.enqueue(StartBenchmarkExecutionJob.new(benchmark_definition.id, benchmark_execution.id), PRIORITY_HIGH)
    else
      puts "Vagrant up failed. See logfile: #{log_file}"
      benchmark_execution.status = 'FAILED ON PREPARING'
      benchmark_execution.save
    end
  end
end