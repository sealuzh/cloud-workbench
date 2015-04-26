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


### OTHER COOKBOOKS
# Apt
default['apt']['compile_time_update'] = true
# Build essential
default['build-essential']['compile_time'] = true

# Rackbox
default['rackbox']['ruby']['versions'] = 	   [ '2.1.1' ]
default['rackbox']['ruby']['global_version'] =   '2.1.1'
default['rackbox']['apps']['unicorn'] = [
    'appname' => 'cloud_benchmarking',
    # Listen to every ip as default. Make sure the default nginx config is disabled (done in recipe)
    # Alternatively use: node['cloud_v2']['public_ipv4'] or node['cloud_v2']['public_hostname'] => (e.g. ec2-54-195-245-183.eu-west-1.compute.amazonaws.com)
    # but this only works with Ohai installation (will be installed with Chef)
    # You may have to provision a second time after a fresh initial installation.
    'hostname' => '0.0.0.0'
  ]
# Nginx
# Use larger bucket size as the default 64 bit may not work with long hostnames (e.g. aws domain names)
default['nginx']['server_names_hash_bucket_size'] = 128

# Vagrant configuration
default['vagrant']['url'] = 'https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3_x86_64.deb'
default['vagrant']['checksum'] = '0fc3259cf08b693e3383636256734513ee93bf258f8328efb64e1dde447aadbe'
default['vagrant']['plugins'] = [
    { 'name' => 'vagrant-aws', 	   'version' =>  '0.5.0' },
    { 'name' => 'vagrant-google',  'version' =>  '0.1.4' },
    { 'name' => 'vagrant-omnibus', 'version' =>  '1.4.1' },
    { 'name' => 'vagrant-butcher', 'version' =>  '2.2.0' },
  ]
default['vagrant']['plugins_user'] = 'apps'
default['vagrant']['plugins_group'] = 'apps'
