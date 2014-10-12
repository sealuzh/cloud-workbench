# Update package index
include_recipe 'apt'
# Install benchmark via package manager
package 'sysbench'


RUBY = "#{Chef::Config.embedded_dir}/bin/ruby"
# Generate benchmark start run hook script
template "#{node['benchmark']['dir']}/#{node['benchmark']['start']}" do
  source 'run_benchmark.rb.erb'
  owner node['benchmark']['owner']
  group node['benchmark']['group']
  mode '0755'
  variables(
      ruby: RUBY,
      cpu_max_prime: node['demo-bench']['cpu_max_prime']
  )
end
