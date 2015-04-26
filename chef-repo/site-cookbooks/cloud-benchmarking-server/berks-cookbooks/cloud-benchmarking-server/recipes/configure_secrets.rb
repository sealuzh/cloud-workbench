def detect_public_ip
  cmd = Mixlib::ShellOut.new('curl http://ipecho.net/plain')
  cmd.run_command
  cmd.stdout
rescue
  default_ip = node['ipaddress'] || 'localhost'
  Chef::Log.warn("Could not detect public ip. Using: #{default_ip}.")
  default_ip
end

app_user_home = node["appbox"]["apps_dir"]
app_user = node["appbox"]["apps_user"]

# .profile
cwb_server_ip = detect_public_ip
template "#{app_user_home}/.profile" do
  source "dot_profile.erb"
  backup false
  owner app_user
  group app_user
  mode 0600
  variables(chef:   node["cloud-benchmarking-server"]["chef"],
            aws:    node["cloud-benchmarking-server"]["aws"],
            google: node["cloud-benchmarking-server"]["google"],
            cwb_server_ip: cwb_server_ip)
end

# Chef server config
chef_dir = "#{app_user_home}/.chef"
# .chef directory
directory chef_dir do
  owner app_user
  group app_user
  mode 00755
end

# knife.rb
template "#{chef_dir}/knife.rb" do
  source "knife.rb.erb"
  backup false
  owner app_user
  group app_user
  mode 0644
  variables home_dir: app_user_home
end

# Client key of node
template "#{chef_dir}/#{node["cloud-benchmarking-server"]["chef"]["client_key_name"]}.pem" do
  source "empty.erb"
  backup false
  owner app_user
  group app_user
  mode 0600
  variables content: node["cloud-benchmarking-server"]["chef"]["client_key"]
end

# Chef validator key
template "#{chef_dir}/chef-validator.pem" do
  source "empty.erb"
  backup false
  owner app_user
  group app_user
  mode 0600
  variables content: node["cloud-benchmarking-server"]["chef"]["validator_key"]
end


# AWS config
template "#{app_user_home}/.ssh/#{node["cloud-benchmarking-server"]["aws"]["ssh_key_name"]}.pem" do
  source "empty.erb"
  backup false
  owner app_user
  group app_user
  mode 0600
  variables content: node["cloud-benchmarking-server"]["aws"]["ssh_key"]
end

# Google config
require "base64"
api_key = Base64.decode64(node["cloud-benchmarking-server"]["google"]["api_key"])
template "#{app_user_home}/.ssh/#{node["cloud-benchmarking-server"]["google"]["api_key_name"]}.p12" do
  source "empty.erb"
  backup false
  owner app_user
  group app_user
  mode 0600
  variables content: api_key
end