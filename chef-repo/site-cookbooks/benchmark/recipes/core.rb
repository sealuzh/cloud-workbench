# TODO: Support hierarchical directory creation.
#       Do NOT use the hierarchical flag of the Chef resource as this
#       does not correctly apply owner and group permissions.
directory node["benchmark"]["dir"] do
  owner node["benchmark"]["owner"]
  group node["benchmark"]["group"]
  mode 0755
  action :create
end

redirect_io = node["benchmark"]["redirect_io"].to_s == 'true'
template "#{node["benchmark"]["dir"]}/#{node["benchmark"]["start_runner"]}" do
  owner node["benchmark"]["owner"]
  group node["benchmark"]["group"]
  mode 00755
  variables(benchmark_start: node["benchmark"]["start"],
            redirect_io: redirect_io)
  source 'start_runner.sh.erb'
end

template "#{node["benchmark"]["dir"]}/#{node["benchmark"]["stop_and_postprocess_runner"]}" do
  owner node["benchmark"]["owner"]
  group node["benchmark"]["group"]
  mode 00755
  variables(stop_and_postprocess: node["benchmark"]["stop_and_postprocess"],
            redirect_io: redirect_io)
  source 'stop_and_postprocess_runner.sh.erb'
end

# Requires the provider_name and provider_instance_id to be set in advance
workbench_server = data_bag_item('benchmark', 'workbench_server')
template "#{node["benchmark"]["dir"]}/benchmark_helper.rb" do
  owner node["benchmark"]["owner"]
  group node["benchmark"]["group"]
  mode 00755
  variables(workbench_server:     workbench_server['value'],
            provider_name:        node["benchmark"]["provider_name"],
            provider_instance_id: node["benchmark"]["provider_instance_id"])
  source 'benchmark_helper.rb.erb'
end