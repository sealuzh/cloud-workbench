#
# Cookbook Name:: fio-benchmark
# Recipe:: default
#

if node[:fio][:install_source]
  include_recipe 'build-essential'
  include_recipe 'fio-benchmark::install_source'
else
  include_recipe 'fio-benchmark::install_apt'
end


# Configure benchmark
client = data_bag_item('cloud-benchmarking', 'client')


template "#{client['benchmark_dir']}/fio-write-job.ini" do
  source 'fio-write-job.ini.erb'
end



# Assumes that rest-client gem is installed within the Chef omnibus installer (which should be the case)
RUBY = "#{Chef::Config.embedded_dir}/bin/ruby"

template "#{BENCHMARK_DIR}/start_benchmark.sh" do
  owner "root"
  group "root"
  mode 00755
  variables(ruby: RUBY)
  source 'start_benchmark.sh.erb'
end

template "#{BENCHMARK_DIR}/start_postprocessing.sh" do
  owner "root"
  group "root"
  mode 00755
  variables(ruby: RUBY)
  source 'start_postprocessing.sh.erb'
end


# Create a class/module within libraries to support multiple providers
AWS_INSTANCE_ID_REQUEST = 'wget -q -O - http://169.254.169.254/latest/meta-data/instance-id'
INSTANCE_ID = %x("#{AWS_INSTANCE_ID_REQUEST}")

# Think about setting a default e.g. node['chef-server']['fqdn']
workbench_server = data_bag_item('benchmark', 'workbench_server')
template "#{BENCHMARK_DIR}/benchmark_helper.rb" do
  owner "root"
  group "root"
  mode 00755
  variables(workbench_server: workbench_server['value'],
            instance_id: INSTANCE_ID)
  source 'benchmark_helper.rb.erb'
end
