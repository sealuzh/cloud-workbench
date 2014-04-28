#
# Cookbook Name:: appbox
# Recipe:: default
#

include_recipe "appbox::package_update"
include_recipe "appbox::users"
include_recipe "appbox::apps_dir"
include_recipe "appbox::tools"
