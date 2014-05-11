# Update package index
include_recipe 'apt'

# Install some required benchmarks via apt
package "sysbench" do
  action :install
end