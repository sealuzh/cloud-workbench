class StartBenchmarkExecutionJob < Struct.new(:benchmark_definition_id, :benchmark_execution_id)
  def perform
    benchmark_definition = BenchmarkDefinition.find(benchmark_definition_id)
    benchmark_execution = BenchmarkExecution.find(benchmark_execution_id)

    %x( cd "#{benchmark_definition.vagrant_directory_path}" &&
        vagrant ssh -- "sudo bash -c 'cd /usr/local/cloud-benchmark && pwd; nohup ./start_benchmark.sh > stdout.log 2> stderr.log < /dev/null &'" )
    # TODO: Handle exit code, Find a way to get the pid

    benchmark_execution.status = 'RUNNING'
    benchmark_execution.save
  end
end