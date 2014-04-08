class PrepareBenchmarkExecutionJob < Struct.new(:benchmark_definition_id, :benchmark_execution_id)
  PRIORITY_HIGH = 1

  def perform
    puts "Preparing benchmark with id #{benchmark_definition_id}"
    benchmark_definition = BenchmarkDefinition.find(benchmark_definition_id)
    benchmark_execution = BenchmarkExecution.find(benchmark_execution_id)

    benchmark_execution.status = 'PREPARING'
    benchmark_execution.start_time = Time.now
    benchmark_execution.save

    %x( cd "#{benchmark_definition.vagrant_directory_path}" &&
        vagrant up --provider=aws )
    # TODO: Handle stdout, stderr redirection into a logging directory (not . due to vagrant sync, which may result in an endless loop) and exit_code

    benchmark_execution.end_time = Time.now # TODO: Save timestamp on each state transition (this is the wrong place for end_time!) => Use a state model
    benchmark_execution.status = 'WAITING'
    benchmark_execution.save

    # Schedule StartBenchmarkExecutionJobs with higher priority than PrepareBenchmarkExecutionJobs.
    # Also consider using multiple queues since long running prepare tasks should not block short running start commands.
  Delayed::Job.enqueue(StartBenchmarkExecutionJob.new(benchmark_definition.id, benchmark_execution.id), PRIORITY_HIGH)
  end
end