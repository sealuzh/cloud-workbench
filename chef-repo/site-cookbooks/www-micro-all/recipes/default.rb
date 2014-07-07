#
# Cookbook Name:: www-micro-all
# Recipe:: default
#
# Copyright 2014, seal uzh
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install individual benchmarks
include_recipe "www-micro-cpu::install"
include_recipe "www-micro-io::install"
include_recipe "www-micro-mem::install"

RUBY = "#{Chef::Config.embedded_dir}/bin/ruby"
# Start
template "#{node['benchmark']['dir']}/#{node['benchmark']['start']}" do
  source "run_benchmark.erb"
  owner node['benchmark']['owner']
  group node['benchmark']['group']
  mode "0755"
  variables(
      ruby: RUBY,
      metric: node['all']['metric_definition_id'],
      max_prime: node['all']['max_prime'],
      repetitions: node['all']['repetitions'],
      threads: node['all']['threads'],
      file_size: node['all']['file_size'],
      max_time: node['all']['max_time'],
      frame_size: node['all']['frame_size'],
      bench_rep: node['all']['bench_rep']
  )
end