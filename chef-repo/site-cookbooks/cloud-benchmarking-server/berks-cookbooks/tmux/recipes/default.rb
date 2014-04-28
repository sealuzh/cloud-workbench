#
# Cookbook Name:: tmux
# Recipe:: default
#
# Copyright 2010-2013, Opscode, Inc.
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
#

begin
  # Becomes include_recipe 'tmux::_packge'
  # The recipe starts with an underscore because it's not meant to be used
  # in a run_list (and should only be included by this recipe).
  include_recipe "tmux::_#{node['tmux']['install_method']}"
rescue Chef::Exceptions::RecipeNotFound
  Chef::Application.fatal! "'#{node['tmux']['install_method']}' is not a valid installation method for the tmux cookbook!"
end

template '/etc/tmux.conf' do
  source 'tmux.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  variables(
    :server_opts  => node['tmux']['server_opts'].to_hash,
    :session_opts => node['tmux']['session_opts'].to_hash,
    :window_opts  => node['tmux']['window_opts'].to_hash
  )
end
