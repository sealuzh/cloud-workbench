#
# Cookbook Name:: timezone-ii
# Recipe:: debian
#
# Copyright 2010, James Harton <james@sociable.co.nz>
# Copyright 2013, Lawrence Leonard Gilbert <larry@L2G.to>
#
# Apache 2.0 License.
#

# Set timezone for Debian family:  Put the timezone string in plain text in
# /etc/timezone and then re-run the tzdata configuration to pick it up.

template "/etc/timezone" do
  source "timezone.conf.erb"
  owner 'root'
  group 'root'
  mode 0644
  notifies :run, 'bash[dpkg-reconfigure tzdata]'
end

bash 'dpkg-reconfigure tzdata' do
  user 'root'
  code "/usr/sbin/dpkg-reconfigure -f noninteractive tzdata"
  action :nothing
end

# vim:ts=2:sw=2:
