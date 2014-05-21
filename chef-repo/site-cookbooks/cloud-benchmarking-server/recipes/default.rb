#
# Cookbook Name:: cloud-benchmarking-server
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

include_recipe "apt"
include_recipe "timezone-ii"
include_recipe "ntp"
include_recipe "vim"
include_recipe "vagrant"
include_recipe "cbench-nodejs"
include_recipe "cbench-databox"
include_recipe "cbench-rackbox"

# Install file permission management utility acl used by Capistrano plugin during deployment
apt_package 'acl'

# Disable the default nginx site
nginx_site 'default' do
  enable false
end


app = {}
app["appname"] = "cloud_benchmarking" # TODO: Fix hardcoded value.
main_dir = File.join(node["appbox"]["apps_dir"], app["appname"])
app_dir    = "#{main_dir}/current"
shared_dir = "#{main_dir}/shared"
config_dir = "#{shared_dir}/config"

# Database config
# IMPORTANT: When using the 'recursive' attribute the owner and group will only
#            be applied to the leaf directory. Therefore the directories must be
#            created manually.
[ main_dir, shared_dir, config_dir ].each do |path|
  directory path do
    owner node["appbox"]["deploy_user"]
    group node["appbox"]["apps_user"]
    mode 0755
  end
end

template "#{config_dir}/database.yml" do
  source "database.yml.erb"
  owner node["appbox"]["deploy_user"]
  group node["appbox"]["apps_user"]
  mode 0755
end


# Delayed job workers
# TODO: Refactor into own recipe later
num_workers = node["cloud-benchmarking-server"]["delayed_job"]["worker_processes"].to_i
num_workers.times do |worker|
  service_name = "delayed_job#{worker + 1}"
  runit_service service_name do
    run_template_name  node["cloud-benchmarking-server"]["delayed_job"]["template_name"]
    log_template_name  node["cloud-benchmarking-server"]["delayed_job"]["template_name"]
    cookbook           node["cloud-benchmarking-server"]["delayed_job"]["template_cookbook"]
    options(
      :user                 => node["appbox"]["apps_user"],
      :group                => node["appbox"]["apps_user"],
      :rack_env             => node["cloud-benchmarking-server"]["delayed_job"]["env"],
      :working_directory    => app_dir,
      :service_name         => service_name,
      :home_dir             => node["appbox"]["apps_dir"]
    )

    # TODO: provide as configurable attribute instead of hardcoding here
    # The BUNDLE_GEMFILE environment variable is required if running rails apps with unicorn.
    # Otherwise unicorn would fail on startup with a 'Bundler::GemfileNotFound' exception searching
    # within another directory for the Gemfile (e.g. searching in 'shared/Gemfile')
    # See: http://blog.willj.net/2011/08/02/fixing-the-gemfile-not-found-bundlergemfilenotfound-error/
    env(
      'BUNDLE_GEMFILE'      => File.join(app_dir, 'Gemfile'),
      'BUNDLE_PATH'         => File.absolute_path(File.join(app_dir, '../shared/vendor/bundle')), # Symlinked to shared/vendor/bundle
      'RAILS_ENV'           => 'production',
      'HOME'                => node["appbox"]["apps_dir"]
    )
    restart_on_update false
  end
end


app_user_home = node["appbox"]["apps_dir"]
app_user = node["appbox"]["apps_user"]
# .profile
unless node["cloud-benchmarking-server"]["preserve_secret_config"]
  template "#{app_user_home}/.profile" do
    source "dot_profile.erb"
    owner app_user
    group app_user
    mode 0600
    variables chef: node["cloud-benchmarking-server"]["chef"],
              aws:  node["cloud-benchmarking-server"]["aws"]
  end
end

# Chef server config
chef_dir = "#{app_user_home}/.chef"
# .chef directory
directory chef_dir do
  owner app_user
  group app_user
  mode 00755
end

# knife.rb
template "#{chef_dir}/knife.rb" do
  source "knife.rb.erb"
  owner app_user
  group app_user
  mode 0644
  variables home_dir: app_user_home
end

# Client key of node
template "#{chef_dir}/#{node["cloud-benchmarking-server"]["chef"]["client_key_name"]}.pem" do
  source "empty.erb"
  owner app_user
  group app_user
  mode 0600
  variables content: node["cloud-benchmarking-server"]["chef"]["client_key"]
end

# Chef validator key
template "#{chef_dir}/chef-validator.pem" do
  source "empty.erb"
  owner app_user
  group app_user
  mode 0600
  variables content: node["cloud-benchmarking-server"]["chef"]["validator_key"]
end


# AWS config
template "#{app_user_home}/.ssh/#{node["cloud-benchmarking-server"]["aws"]["ssh_key_name"]}.pem" do
  source "empty.erb"
  owner app_user
  group app_user
  mode 0600
  variables content: node["cloud-benchmarking-server"]["aws"]["ssh_key"]
end