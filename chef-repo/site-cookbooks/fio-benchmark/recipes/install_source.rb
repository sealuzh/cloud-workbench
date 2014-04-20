# Inspired by http://docs.opscode.com/resource_remote_file.html (Install a file from a remote location using bash) and http://stackoverflow.com/questions/8530593/chef-install-and-update-programs-from-source

include_recipe 'apt'

# Download specific version only if not already present
remote_file "#{Chef::Config[:file_cache_path]}/fio-#{node[:fio][:version]}.tar.gz" do
  source "http://brick.kernel.dk/snaps/fio-#{node[:fio][:version]}.tar.gz"
  notifies :run, "bash[install_fio]", :immediately
  action :create_if_missing
end

# Build specific version from source
bash "install_fio" do
 user "root"
 cwd Chef::Config[:file_cache_path]
 code <<-EOH
  gunzip fio-#{node[:fio][:version]}.tar.gz
  tar -xf fio-#{node[:fio][:version]}.tar
  (cd fio-#{node[:fio][:version]} && ./configure && make && make install)
 EOH
 action :nothing
end