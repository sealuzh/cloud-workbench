#
# Cookbook Name:: vagrant
# Recipe:: default
#
# Copyright 2013, Joshua Timberman
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

include_recipe "vagrant::#{node['platform_family']}"

node['vagrant']['plugins'].each do |plugin|
  if plugin.respond_to?(:keys)

    vagrant_plugin plugin['name'] do
      version plugin['version']
      user node['current_user']
    end

  else

    vagrant_plugin plugin do
      user node['current_user']
    end

  end
end

node['vagrant']['boxes'].each do |box|
  if box.respond_to?(:keys)
    vagrant_box box['name'] do
      uri box['uri']
      user node['current_user']
    end
  end
end
