case node['platform_family']
  when 'debian'
    # Update package index
    include_recipe 'apt'
end

package 'sysbench' do
  action :install
end
