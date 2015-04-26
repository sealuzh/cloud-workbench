include_recipe 'cloud-benchmarking-server::configure_application'

if node['cloud-benchmarking-server']['apply_secret_config']
  include_recipe 'cloud-benchmarking-server::configure_secrets'
end
