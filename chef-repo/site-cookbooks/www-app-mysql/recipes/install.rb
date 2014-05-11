# Update package index
include_recipe 'apt'
include_recipe 'mysql::server'

# Install some required benchmarks via apt
package "sysbench" do
  action :install
end

