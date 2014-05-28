# Update package index
include_recipe 'apt'

# Install some required benchmarks via apt
package "sysbench" do
    action :install
end

# copy ruby script with the benchmark
cookbook_file "#{node['benchmark']['dir']}/sysbench-io.rb" do
  source "sysbench-io.rb"
  owner node['benchmark']['owner']
  group node['benchmark']['group']
end