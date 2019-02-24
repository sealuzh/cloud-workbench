# frozen_string_literal: true

class StartPostprocessingJob < Struct.new(:benchmark_execution_id)
  def perform
    benchmark_execution = BenchmarkExecution.find(benchmark_execution_id)
    benchmark_execution.start_postprocessing
  end
end
