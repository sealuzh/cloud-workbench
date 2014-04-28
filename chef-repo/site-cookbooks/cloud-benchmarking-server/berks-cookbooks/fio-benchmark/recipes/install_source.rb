# Inspired by:
#  * Install a file from a remote location using bash:
#     http://docs.opscode.com/resource_remote_file.html
#  * Install a program from source:
#     http://stackoverflow.com/questions/8530593/chef-install-and-update-programs-from-source

include_recipe 'apt'
include_recipe 'build-essential'


# Download specific version only if not already present
remote_file "#{Chef::Config['file_cache_path']}/fio-#{node['fio']['version']}.tar.gz" do
  source node['fio']['source_url']
  action :create_if_missing
  notifies :run, "bash[install_fio]", :immediately
end

# Build specific version from source
bash "install_fio" do
 cwd Chef::Config['file_cache_path']
 code <<-EOH
  gunzip fio-#{node['fio']['version']}.tar.gz
  tar -xf fio-#{node['fio']['version']}.tar
  (cd fio-#{node['fio']['version']} && ./configure && make && sudo make install)
 EOH
 action :nothing
end