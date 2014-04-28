#
# Cookbook Name:: appbox
# Recipe:: apps_dir
#
# Setup base dir for apps deployment.
#
# IMPORTANT: It assumes node["appbox"]["apps_user"] user already exists.
#

def user_exists?(username)
  !!Etc.getpwnam(username) rescue false
end

unless user_exists? node["appbox"]["apps_user"]
  include_recipe "appbox::users"
end

directory node['appbox']['apps_dir'] do
  mode "2775"
  owner node["appbox"]["apps_user"]
  group node["appbox"]["apps_user"]
  action :create
  recursive true
end
