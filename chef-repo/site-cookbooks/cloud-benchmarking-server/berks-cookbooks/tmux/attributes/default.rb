#
# Cookbook Name:: tmux
# Attribute:: default
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

default['tmux']['install_method'] = case node['platform_family']
                                    when 'rhel'
                                      'source'
                                    else
                                      'package'
                                    end

default['tmux']['version'] = '1.8'
default['tmux']['checksum'] = 'f265401ca890f8223e09149fcea5abcd6dfe75d597ab106e172b01e9d0c9cd44'

default['tmux']['configure_options'] = []

default['tmux']['server_opts']['escape-time'] = 1

default['tmux']['session_opts']['base-index'] = 1
default['tmux']['session_opts']['prefix'] = 'C-a'

default['tmux']['window_opts']['pane-base-index'] = 1
