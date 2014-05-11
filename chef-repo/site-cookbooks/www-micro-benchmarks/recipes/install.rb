# Update package index
include_recipe 'apt'

# Install some required benchmarks via apt
%w{mbw sysbench}.each do |pkg|
  package pkg do
    action :install
  end
end