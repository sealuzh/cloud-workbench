# Update api_fqdn with public_hostname from Ohai if available
# Cannot be an ip address (e.g. node["cloud_v2"]["public_ipv4"] causes api services such as the cookbook service bookshelf to fail)
default["chef-server"]["api_fqdn"] = node["cloud_v2"]["public_hostname"] || node["chef-server"]["api_fqdn"]

# This will cause that two api_fqdn entries appear (it's a bug in https://github.com/opscode-cookbooks/chef-server/blob/v2.1.4/templates/default/chef-server.rb.erb)
# default["chef-server"]["configuration"]["api_fqdn"] = node["cloud_v2"]["public_hostname"] || "localhost"
