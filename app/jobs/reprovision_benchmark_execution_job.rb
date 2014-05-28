class ReprovisionBenchmarkExecutionJob < Struct.new(:benchmark_execution_id)
  def perform
    benchmark_execution = BenchmarkExecution.find(benchmark_execution_id)
    benchmark_execution.reprovision
  end
end