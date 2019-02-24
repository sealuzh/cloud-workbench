# frozen_string_literal: true

class StartBenchmarkExecutionJob < Struct.new(:benchmark_execution_id)
  def perform
    benchmark_execution = BenchmarkExecution.find(benchmark_execution_id)
    benchmark_execution.start_benchmark
  end
end