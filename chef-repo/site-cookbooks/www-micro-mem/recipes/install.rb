# Update package index
include_recipe 'apt'

# Install some required benchmarks via apt
package "mbw" do
  action :install
end