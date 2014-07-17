include_recipe 'timezone-ii'
include_recipe 'ntp'

# Disable the default nginx site
nginx_site 'default' do
  enable false
end

include_recipe 'cloud-benchmarking-server::configure_application'


if node['cloud-benchmarking-server']['apply_secret_config']
  include_recipe 'cloud-benchmarking-server::configure_secrets'
end
