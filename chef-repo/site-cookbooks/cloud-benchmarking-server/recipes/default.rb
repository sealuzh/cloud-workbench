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

node.override["rackbox"]["apps"]["unicorn"] = [
  "appname" => "cloud_benchmarking",
  # Only works with Ohai installation (will be installed with Chef)
  # You must provision a second time after a fresh initial installation.
  # Alternatively use: node["cloud_v2"]["public_hostname"] => (e.g. ec2-54-195-245-183.eu-west-1.compute.amazonaws.com)
  "hostname" => node["cloud_v2"]["public_ipv4"] || "localhost"
  ]

include_recipe "apt"
include_recipe "vim"
include_recipe "vagrant"
include_recipe "cbench-databox"
include_recipe "cbench-rackbox"
include_recipe "cbench-nodejs"

# Consider configuring the database.yml based on the chosen database, password and db name here
# instead of pushing this configuration later via Capistrano.

# TODO: Needs testing! A paremetrized loop may be required for multiple workers!?
# Refactor into own recipe later
=begin
# Delayed job worker(s)
app["appname"] = "cloud_benchmarking" # TODO: Fix hardcoded value.
app_dir = ::File.join(node["appbox"]["apps_dir"], app["appname"], 'current')
runit_service "delayed_job" do
	run_template_name  node["cloud-benchmarking-server"]["delayed_job"]["template_name"]
	log_template_name  node["cloud-benchmarking-server"]["delayed_job"]["template_name"]
	cookbook           node["cloud-benchmarking-server"]["delayed_job"]["template_cookbook"]
	options(
		:user                 => node["appbox"]["apps_user"],
		:group                => node["appbox"]["apps_user"],
		:rack_env             => node["cloud-benchmarking-server"]["delayed_job"]["env"],
    :working_directory    => app_dir,
    :app_name             => app["appname"]
  )
  # The BUNDLE_GEMFILE environment variable is required if running rails apps with unicorn.
  # Otherwise unicorn would fail on startup with a 'Bundler::GemfileNotFound' exception searching
  # within another directory for the Gemfile (e.g. searching in 'shared/Gemfile')
  # See: http://blog.willj.net/2011/08/02/fixing-the-gemfile-not-found-bundlergemfilenotfound-error/
  env(
    'BUNDLE_GEMFILE'      => File.join(app_dir, 'Gemfile'),
    'BUNDLE_PATH'         => File.absolute_path(File.join(app_dir, '../shared/vendor/bundle')) # Symlinked to shared/vendor/bundle
  )
	restart_on_update false
end
=end