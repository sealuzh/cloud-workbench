# Delayed job
default['cloud-benchmarking-server']['delayed_job']['worker_processes'] = '1'
default['cloud-benchmarking-server']['delayed_job']['template_name'] = 'delayed_job'
default['cloud-benchmarking-server']['delayed_job']['template_cookbook'] = 'cloud-benchmarking-server'
default['cloud-benchmarking-server']['delayed_job']['env'] = 'production'

# Chef
default['cloud-benchmarking-server']['chef']['server_ip'] = '33.33.33.50'
default['cloud-benchmarking-server']['chef']['node_name'] = 'cloud-benchmarking'
default['cloud-benchmarking-server']['chef']['client_key_name'] = 'cloud-benchmarking'
default['cloud-benchmarking-server']['chef']['client_key'] = ''
default['cloud-benchmarking-server']['chef']['validator_key'] = ''

# Secret config
default['cloud-benchmarking-server']['apply_secret_config'] = true

# AWS
default['cloud-benchmarking-server']['aws']['ssh_key_name'] = 'cloud-benchmarking'
default['cloud-benchmarking-server']['aws']['ssh_key'] = ''
default['cloud-benchmarking-server']['aws']['access_key'] = ''
default['cloud-benchmarking-server']['aws']['secret_key'] = ''

# Google
default['cloud-benchmarking-server']['google']['project_id'] = ''
default['cloud-benchmarking-server']['google']['client_email'] = ''
default['cloud-benchmarking-server']['google']['api_key_name'] = 'google-compute'
default['cloud-benchmarking-server']['google']['api_key'] = ''
