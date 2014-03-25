json.array!(@metric_definitions) do |metric_definition|
  json.extract! metric_definition, :id, :name, :unit
  json.url metric_definition_url(metric_definition, format: :json)
end
