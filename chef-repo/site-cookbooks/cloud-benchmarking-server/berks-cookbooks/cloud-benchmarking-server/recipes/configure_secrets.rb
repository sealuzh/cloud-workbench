app_user_home = node["appbox"]["apps_dir"]
app_user = node["appbox"]["apps_user"]

# .profile
template "#{app_user_home}/.profile" do
  source "dot_profile.erb"
  backup false
  owner app_user
  group app_user
  mode 0600
  variables chef:   node["cloud-benchmarking-server"]["chef"],
            aws:    node["cloud-benchmarking-server"]["aws"],
            google: node["cloud-benchmarking-server"]["google"],
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
template "#{app_user_home}/.ssh/#{node["cloud-benchmarking-server"]["google"]["api_key_name"]}.p12" do
  source "empty.erb"
  backup false
  owner app_user
  group app_user
  mode 0600
  variables content: node["cloud-benchmarking-server"]["google"]["api_key"]
end