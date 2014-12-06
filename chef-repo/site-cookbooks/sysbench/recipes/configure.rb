# Use embedded Chef Ruby
RUBY = "#{Chef::Config.embedded_dir}/bin/ruby"

# Benchmark start hook
template "#{node['benchmark']['dir']}/#{node['benchmark']['start']}" do
  source "run_benchmark.rb.erb"
  owner node['benchmark']['owner']
  group node['benchmark']['group']
  mode "0755"
  variables(
      ruby: RUBY,
      metric_definition_id: node['sysbench']['metric_definition_id'],
      cli_options: node['sysbench']['cli_options'],
      repetitions: node['sysbench']['repetitions'],
      threads: node['cpu']['total'] || node['sysbench']['default_threads'],
      cpu_model: node['cpu']['model_name'],
  )
end
