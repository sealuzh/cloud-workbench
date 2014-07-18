#
# Cookbook Name:: htop
# Recipe:: default
#

include_recipe "yum-repoforge" if platform_family?("rhel")

package "htop" do
  version node["htop"]["version"]
end
