# Apt
node.default['apt']['compile_time_update'] = true

# Build essential
node.default['build-essential']['compile_time'] = true

# Rackbox
node.default['rackbox']['ruby']['versions']       = [ '2.1.1' ]
node.default['rackbox']['ruby']['global_version'] =   '2.1.1'
node.default['rackbox']['apps']['unicorn'] = [
    'appname' => 'cloud_benchmarking',
    # Listen to every ip as default. Make sure the default nginx config is disabled (done in recipe)
    # Alternatively use: node['cloud_v2']['public_ipv4'] or node['cloud_v2']['public_hostname'] => (e.g. ec2-54-195-245-183.eu-west-1.compute.amazonaws.com)
    # but this only works with Ohai installation (will be installed with Chef)
    # You may have to provision a second time after a fresh initial installation.
    'hostname' => '0.0.0.0'
  ]

# Nginx
# Use larger bucket size as the default 64 bit may not work with long hostnames (e.g. aws domain names)
node.default['nginx']['server_names_hash_bucket_size'] = 128

# Vagrant
node.default['vagrant']['url'] = 'https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3_x86_64.deb'
node.default['vagrant']['checksum'] = '0fc3259cf08b693e3383636256734513ee93bf258f8328efb64e1dde447aadbe'
node.default['vagrant']['plugins'] = [
    { 'name' => 'vagrant-aws',     'version' =>  '0.5.0' },
    { 'name' => 'vagrant-google',  'version' =>  '0.1.4' },
    { 'name' => 'vagrant-omnibus', 'version' =>  '1.4.1' },
    { 'name' => 'vagrant-butcher', 'version' =>  '2.2.0' },
  ]
node.default['vagrant']['plugins_user'] = 'apps'
node.default['vagrant']['plugins_group'] = 'apps'
