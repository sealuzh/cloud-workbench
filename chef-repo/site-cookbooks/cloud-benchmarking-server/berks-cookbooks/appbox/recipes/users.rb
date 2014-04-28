# Cookbook Name:: appbox
# Recipe:: users
#
# Setup default users, groups and sudoers for
# apps deployment purpose.
#

include_recipe "user"

user_account node["appbox"]["apps_user"] do
  comment "apps runner"
end
user_account node["appbox"]["deploy_user"] do
  comment "deployer"
  ssh_keys node["appbox"]["deploy_keys"]
end
user_account node["appbox"]["admin_user"] do
  comment "sysadmin"
  ssh_keys node["appbox"]["admin_keys"]
end

group node["appbox"]["apps_user"] do
  action :modify
  members [
    node["appbox"]["apps_user"],
    node["appbox"]["admin_user"],
    node["appbox"]["deploy_user"]
  ]
end

node.default["authorization"]["sudo"]["groups"] = [
  "sudo",
  node["appbox"]["admin_user"],
  node["appbox"]["deploy_user"]  # TODO workaround to enable deployer to restart app
]
node.default["authorization"]["sudo"]["passwordless"] = true
include_recipe "sudo"

