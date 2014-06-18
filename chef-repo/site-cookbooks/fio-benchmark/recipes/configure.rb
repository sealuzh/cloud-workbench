# Create the fio job ini configuration template
template "#{node['benchmark']['dir']}/#{node['fio']['config_file']}" do
  owner node['benchmark']['owner']
  group node['benchmark']['group']
  variables(
    config: node['fio']['config']
  )
  source node['fio']['template_name']
  cookbook node['fio']['template_cookbook']
end

# Postprocessing helper
 cookbook_file "#{node['benchmark']['dir']}/fio_log_parser.rb" do
  source "fio_log_parser.rb"
  owner node['benchmark']['owner']
  group node['benchmark']['group']
  mode "0755"
end