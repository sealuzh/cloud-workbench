# Use embedded Chef Ruby
RUBY = "#{Chef::Config.embedded_dir}/bin/ruby"

# Benchmark start hook
template "#{node['benchmark']['dir']}/#{node['benchmark']['start']}" do
  source 'run_benchmark.rb.erb'
  owner node['benchmark']['owner']
  group node['benchmark']['group']
  mode '0755'
  variables(
      ruby: RUBY,
      cli_options: node['sysbench']['cli_options'],
      cpu_model: node['cpu']['0']['model_name'],
  )
end
