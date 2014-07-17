app_user = node['appbox']['apps_user']
app_user_home = node['appbox']['apps_dir']

source = 'vagrant-google-0.1.2.gem'
tmp_path = "#{Chef::Config['file_cache_path']}/#{source}"
cookbook_file tmp_path do
	source source
	owner app_user
	group app_user
	mode '0644'
end

execute 'install_vagrant_google' do
	command "vagrant plugin install #{tmp_path}"
  user app_user
  group app_user
  environment({ 'HOME' => app_user_home })
	action :run
end
