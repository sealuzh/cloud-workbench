# Install fio via apt
# - Only some older releases: http://packages.ubuntu.com/search?keywords=fio&searchon=names

# Update package index
include_recipe 'apt'

# Install fio benchmark via apt package manager
apt_package 'fio'
  action :install
end
