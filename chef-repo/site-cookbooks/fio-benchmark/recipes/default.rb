RUBY = "#{Chef::Config.embedded_dir}/bin/ruby"

include_recipe "fio-benchmark::install_#{node['fio']['install_method']}"
include_recipe "fio-benchmark::configure"


# Start benchmark
template "#{node['benchmark']['dir']}/#{node['benchmark']['start']}" do
  source "start.rb.erb"
  owner node['benchmark']['owner']
  group node['benchmark']['group']
  mode "0755"
  variables(
    ruby: RUBY,
    config_file: node['fio']['config_file'],
    cli_options: node['fio']['cli_options'],
    fio_log: "#{node['fio']['config']['write_bw_log']}_bw.log",
    metric_definition_id: node['fio']['metric_definition_id'],
    cpu: node['cpu']['0']['model_name']
  )
end
