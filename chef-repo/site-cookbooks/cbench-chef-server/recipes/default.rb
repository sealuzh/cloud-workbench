#
# Cookbook Name:: cbench-chef-server
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

include_recipe 'chef-server'

# Set Chef api_fqdn via Ohai provided public hostname
old_config = node['chef-server']['configuration']
old_api_fqdn = old_config['api_fqdn']
new_api_fqdn = api_fqdn: node['public_hostname']
new_config = old_config.merge({new_api_fqdn})
node.override['chef-server']['configuration'] = new_config

# node.override['fqdn'] = node['public_hostname']

puts "old_api_fqdn=#{old_api_fqdn} => new_api_fqdn=#{new_api_fqdn}"

execute "reconfigure chef-server on configuration change" do
	command "sudo chef-server-ctl reconfigure"
	action :run, not_if old_api_fqdn == new_api_fqdn
end