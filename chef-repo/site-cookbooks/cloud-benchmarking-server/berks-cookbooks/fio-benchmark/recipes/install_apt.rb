# Install fio via apt
# - Only some older releases available:
#     http://packages.ubuntu.com/search?keywords=fio&searchon=names

# Update package index
include_recipe 'apt'

# Install fio benchmark via apt package manager
apt_package 'fio' do
  action :install
end
