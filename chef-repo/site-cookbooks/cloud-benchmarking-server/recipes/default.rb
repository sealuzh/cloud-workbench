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
package 'acl'

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
# IMPORTANT: If using the 'recursive' attribute the owner and group will only
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
  backup false
  owner node["appbox"]["deploy_user"]
  group node["appbox"]["apps_user"]
  mode 0755
  variables database_name: node["databox"]["databases"]["postgresql"][0]["database_name"],
            username:      node["databox"]["databases"]["postgresql"][0]["username"],
            password:      node["databox"]["databases"]["postgresql"][0]["password"],
            port:          node["postgresql"]["config"]["port"]
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


if node["cloud-benchmarking-server"]["apply_secret_config"]
  include_recipe "cloud-benchmarking-server::configure_secrets"
end
