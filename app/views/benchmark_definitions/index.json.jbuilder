json.array!(@benchmark_definitions) do |benchmark_definition|
  json.extract! benchmark_definition, :id, :name
  json.url benchmark_definition_url(benchmark_definition, format: :json)
end
