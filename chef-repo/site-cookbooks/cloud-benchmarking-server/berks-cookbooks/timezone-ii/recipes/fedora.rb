#
# Cookbook Name:: timezone-ii
# Recipe:: fedora
#
# Copyright 2013, Lawrence Leonard Gilbert <larry@L2G.to>
#
# Apache 2.0 License.
#

# Set timezone for Fedora by using its timedatectl utility.

bash 'timedatectl set-timezone' do
  user 'root'
  code "/usr/bin/timedatectl --no-ask-password set-timezone #{node.tz}"
end

# vim:ts=2:sw=2:
