class PrepareBenchmarkExecutionJob < Struct.new(:benchmark_definition_id, :benchmark_execution_id)
  def perform
    puts "Preparing benchmark with id #{benchmark_definition_id}"
    benchmark_definition = BenchmarkDefinition.find(benchmark_definition_id)
    benchmark_execution = BenchmarkExecution.find(benchmark_execution_id)

    benchmark_execution.start_time = Time.now
    benchmark_definition.save

    %x( cd "#{benchmark_definition.vagrant_directory_path}";
        vagrant up )
    # TODO: Handle stdout, stderr redirection into a logging directory (not . due to vagrant sync, which may result in an endless loop) and exit_code

    benchmark_execution.end_time = Time.now
    benchmark_execution.save
  end
end