json.array!(@benchmark_executions) do |benchmark_execution|
  json.extract! benchmark_execution, :id, :status, :start_time, :end_time
  json.url benchmark_execution_url(benchmark_execution, format: :json)
end
