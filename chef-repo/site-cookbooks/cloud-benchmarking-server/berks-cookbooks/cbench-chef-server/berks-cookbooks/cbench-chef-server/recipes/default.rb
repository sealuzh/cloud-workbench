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

# Does not work as executed too late
# => no effect on chef-server since chef-server.rb is generated during chef-server recipe
# ruby_block "setup api_fqdn based on Ohai" do
#   block do

# old_config = node['chef-server']['configuration']
# new_api_fqdn = { api_fqdn: node['cloud_v2']['public_hostname'] }
# new_config = old_config.merge(new_api_fqdn)

#     puts "old_config=#{old_config}"
#     puts  '|'
#     puts  'v'
#     puts "new_config=#{new_config}"
#     node.override['chef-server']['configuration'] = new_config

#     # if old_config != new_config
#     #   %x(sudo chef-server-ctl reconfigure)
#     # end
#   end
# end

# execute "reconfigure chef-server on configuration change" do
# 	command "sudo chef-server-ctl reconfigure"
# 	action :run
# 	not_if {old_api_fqdn.to_s == new_api_fqdn.to_s}
# end

