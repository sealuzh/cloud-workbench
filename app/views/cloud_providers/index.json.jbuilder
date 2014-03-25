json.array!(@cloud_providers) do |cloud_provider|
  json.extract! cloud_provider, :id, :name, :credentials_path, :ssh_key_path
  json.url cloud_provider_url(cloud_provider, format: :json)
end
