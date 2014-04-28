#
# Cookbook Name:: htop
# Recipe:: default
#
# Copyright 2011-2012, Phil Cohen
#

if platform_family?("rhel")
  include_recipe "yum::repoforge"
end

package "htop" do
  version node['htop']['version']
end
