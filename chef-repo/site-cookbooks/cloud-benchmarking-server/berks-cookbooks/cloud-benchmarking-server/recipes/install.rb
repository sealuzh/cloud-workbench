include_recipe 'vim'
include_recipe 'apt'
include_recipe 'build-essential'
include_recipe 'vagrant'
include_recipe 'cloud-benchmarking-server::install_vagrant_google'
include_recipe 'cbench-nodejs'
include_recipe 'cbench-databox'
include_recipe 'cbench-rackbox'

# Install file permission management utility acl used by Capistrano plugin during deployment
package 'acl'
