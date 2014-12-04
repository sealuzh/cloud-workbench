# Update package index (Ubuntu or Debian)
include_recipe "apt"

package "sysbench" do
  action :install
end
