#
# Cookbook Name:: benchmark
# Recipe:: default
#
# Copyright (C) 2014 seal uzh
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


directory node["benchmark"]["dir"] do
  owner node["benchmark"]["owner"]
  group node["benchmark"]["group"]
  mode 0755
  action :create
end


template "#{node["benchmark"]["dir"]}/#{node["benchmark"]["start_runner"]}" do
  owner node["benchmark"]["owner"]
  group node["benchmark"]["group"]
  mode 00755
  variables(start: node["benchmark"]["start"])
  source 'start_runner.sh.erb'
end

template "#{node["benchmark"]["dir"]}/#{node["benchmark"]["stop_and_postprocess_runner"]}" do
  owner node["benchmark"]["owner"]
  group node["benchmark"]["group"]
  mode 00755
  variables(stop_and_postprocess: node["benchmark"]["stop_and_postprocess"])
  source 'stop_and_postprocess_runner.sh.erb'
end


# Create a class/module to support multiple providers
# Example response: "i-7705c135"
AWS_INSTANCE_ID_REQUEST = 'wget -q -O - http://169.254.169.254/latest/meta-data/instance-id'
INSTANCE_ID = `#{AWS_INSTANCE_ID_REQUEST}`

# Think about setting a default e.g. node['chef-server']['fqdn']
workbench_server = data_bag_item('benchmark', 'workbench_server')
template "#{node["benchmark"]["dir"]}/benchmark_helper.rb" do
  owner node["benchmark"]["owner"]
  group node["benchmark"]["group"]
  mode 00755
  variables(workbench_server: workbench_server['value'],
            instance_id: INSTANCE_ID)
  source 'benchmark_helper.rb.erb'
end