# frozen_string_literal: true

class PrepareBenchmarkExecutionJob < Struct.new(:benchmark_execution_id)
  def perform
    benchmark_execution = BenchmarkExecution.find(benchmark_execution_id)
    benchmark_execution.prepare
  end
end
