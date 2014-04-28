#
# Author:: Marius Ducea (marius@promethost.com)
# Cookbook Name:: nodejs
# Recipe:: source
#
# Copyright 2010-2012, Promet Solutions
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

# Source: https://github.com/kadishmal/nodejs-cookbook/blob/1b7605b79d852a6d08c5a07220b1bcc3d6d8437c/recipes/install_from_source.rb
# Fixes the issue that nodejs gets rebuild from source on every Chef client run.

require 'chef/shell_out'

def getCurrentInstalledVersion
  @getCurrentInstalledVersion ||= begin
    version_check_cmd = "node --version"
    cmd = Mixlib::ShellOut.new(version_check_cmd)
    version = cmd.run_command

    output = version.stdout

    if version.status == 0 && output.length > 0
      output.gsub(/[v]/, "")
    else
      ""
    end
  rescue Errno::ENOENT
    # Node.js seems to be not installed, so return an empty string.
    ""
  end
end

current_installed_version = getCurrentInstalledVersion

major_minor_version = node['nodejs']['version'].split(".")
major_minor_version = major_minor_version[0] << "." << major_minor_version[1]

# Check if Node.js is installed and whether the installed version is older
# than the one defined in the recipe attributes.
# Update only when the patch version is smaller than the new available version,
# i.e. if v0.10.0 is installed, updated it only if a newer v0.10.x is available.
if current_installed_version.length == 0 || current_installed_version < node['nodejs']['version'] && current_installed_version.index(major_minor_version) == 0
  include_recipe "build-essential"

  case node['platform_family']
    when 'rhel','fedora'
      package "openssl-devel"
    when 'debian'
      package "libssl-dev"
  end

  nodejs_tar = "node-v#{node['nodejs']['version']}.tar.gz"
  nodejs_tar_path = nodejs_tar

  if node['nodejs']['version'].split('.')[1].to_i >= 5
    nodejs_tar_path = "v#{node['nodejs']['version']}/#{nodejs_tar_path}"
  end
  # Let the user override the source url in the attributes
  nodejs_src_url = "#{node['nodejs']['src_url']}/#{nodejs_tar_path}"

  remote_file "/usr/local/src/#{nodejs_tar}" do
    source nodejs_src_url
    checksum node['nodejs']['checksum']
    mode 0644
    action :create_if_missing
  end

  # --no-same-owner required overcome "Cannot change ownership" bug
  # on NFS-mounted filesystem
  execute "tar --no-same-owner -zxf #{nodejs_tar}" do
    cwd "/usr/local/src"
    creates "/usr/local/src/node-v#{node['nodejs']['version']}"
  end

  bash "compile node.js (on #{node['nodejs']['make_threads']} cpu)" do
    # OSX doesn't have the attribute so arbitrarily default 2
    cwd "/usr/local/src/node-v#{node['nodejs']['version']}"
    code <<-EOH
      PATH="/usr/local/bin:$PATH"
      ./configure --prefix=#{node['nodejs']['dir']} && \
      make -j #{node['nodejs']['make_threads']}
    EOH
    creates "/usr/local/src/node-v#{node['nodejs']['version']}/node"
  end

  execute "nodejs make install" do
    environment({"PATH" => "/usr/local/bin:/usr/bin:/bin:$PATH"})
    command "make install"
    cwd "/usr/local/src/node-v#{node['nodejs']['version']}"
  end
end

