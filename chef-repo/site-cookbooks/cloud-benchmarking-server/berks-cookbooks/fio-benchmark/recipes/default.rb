#
# Cookbook Name:: fio-benchmark
# Recipe:: default
#

# Install benchmark
include_recipe "fio-benchmark::install_#{node['fio']['install_method']}"


# Configure benchmark
template "#{node['benchmark']['dir']}/#{node['fio']['config_file']}" do
  owner node['benchmark']['owner']
  group node['benchmark']['group']
  variables(
    rw: node['fio']['rw'],
    size: node['fio']['size'],
    bs: node['fio']['bs'],
    write_bw_log: node['fio']['write_bw_log']
  )
  source node['fio']['template_name']
  cookbook node['fio']['template_cookbook']
end

# Benchmark execution hooks
# TODO: Provide Chef LWPR to facilitate benchmark definitions by
# handling owner, group, mode, name, etc in the background
# May be avoided by passing a custom PATH environment variable.

RUBY = "#{Chef::Config.embedded_dir}/bin/ruby"
# Start
template "#{node['benchmark']['dir']}/#{node['benchmark']['start']}" do
  source "start.sh.erb"
  owner node['benchmark']['owner']
  group node['benchmark']['group']
  mode "0755"
  variables(
    ruby: RUBY,
    config_file: node['fio']['config_file'],
    fio: node['fio']['bin']
  )
end

# Stop and postprocessing
template "#{node['benchmark']['dir']}/#{node['benchmark']['stop_and_postprocess']}" do
  source "stop_and_postprocess.sh.erb"
  owner node['benchmark']['owner']
  group node['benchmark']['group']
  mode "0755"
  variables(
    ruby: RUBY,
    metric_definition_id: node['fio']['metric_definition_id'],
    fio_log: "#{node['fio']['write_bw_log']}_bw.log"
  )
end

# Postprocessing helper
template "#{node['benchmark']['dir']}/fio_log_parser.rb" do
  source "fio_log_parser.rb.erb"
  owner node['benchmark']['owner']
  group node['benchmark']['group']
  mode "0755"
end
