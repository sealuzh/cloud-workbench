# Update package index
include_recipe 'apt'

# Install some required packages via apt
%w{openjdk-7-jdk maven git}.each do |pkg|
    package pkg do
      action :install
    end
end

# copy ruby script with the benchmark
cookbook_file "#{node['benchmark']['dir']}/jcloudscale-compile-benchmark.rb" do
  source "jcloudscale-compile-benchmark.rb"
  owner node['benchmark']['owner']
  group node['benchmark']['group']
end