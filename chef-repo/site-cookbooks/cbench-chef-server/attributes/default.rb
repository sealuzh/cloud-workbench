# default["chef-server"]["fqdn"] = # Not known à priori! => reprovision or dynamically set in recipe
# For cloud config see running instance and http://stackoverflow.com/questions/19586040/install-chef-server-11-on-ec2-instance



# Override api_fqdn with public ipv4 if available
default["chef-server"]["api_fqdn"] = node["cloud_v2"]["public_ipv4"] || node["chef-server"]["api_fqdn"]

# This will cause that two api_fqdn entries appear (it's a bug in https://github.com/opscode-cookbooks/chef-server/blob/v2.1.4/templates/default/chef-server.rb.erb)
# default["chef-server"]["configuration"]["api_fqdn"] = node["cloud_v2"]["public_ipv4"] || "localhost"
