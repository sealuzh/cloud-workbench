# Update package index
include_recipe 'apt'

# Install some required benchmarks via apt
package "mbw" do
  action :install
end

# copy ruby script with the benchmark
cookbook_file "#{node['benchmark']['dir']}/membench.rb" do
  source "membench.rb"
  owner node['benchmark']['owner']
  group node['benchmark']['group']
end