json.array!(@metric_observations) do |metric_observation|
  json.extract! metric_observation, :id, :key, :value
  json.url metric_observation_url(metric_observation, format: :json)
end
