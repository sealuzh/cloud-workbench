class ReleaseResourcesJob < Struct.new(:benchmark_definition_id, :benchmark_execution_id)
  def perform
    benchmark_definition = BenchmarkDefinition.find(benchmark_definition_id)
    benchmark_execution = BenchmarkExecution.find(benchmark_execution_id)

    benchmark_execution.status = 'RELEASING_RESOURCES'
    benchmark_execution.save

    %x( cd "#{benchmark_definition.vagrant_directory_path}" &&
        vagrant destroy )
    # TODO: Handle stdout, stderr redirection into a logging directory (not . due to vagrant sync, which may result in an endless loop) and exit_code

    benchmark_execution.status = 'FINISHED'
    benchmark_execution.end_time = Time.now
    benchmark_execution.save
  end
end