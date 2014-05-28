# NOTE: The cookbook service bookshelf won't work (getting 404) without a proper hostname being set.
# Even though you can login into the Chef server and use the web interface, you cannot manage (upload/download) cookbook.
# Cannot be an ip address (e.g. node["cloud_v2"]["public_ipv4"] causes api services such as the cookbook service bookshelf to fail)

# Try to detect the hostname with Ohai
cloud_hostname = (node["cloud_v2"]["public_hostname"] rescue nil)
if cloud_hostname.nil?
  # 0.0.0.0 prevents the provisioning from being aborted but result in unusable cookbook service
  default["chef-server"]["api_fqdn"] = node["chef-server"]["api_fqdn"] || "0.0.0.0"
else
  default["chef-server"]["api_fqdn"] = cloud_hostname
end

# This will cause that two api_fqdn entries appear (it's a bug in https://github.com/opscode-cookbooks/chef-server/blob/v2.1.4/templates/default/chef-server.rb.erb)
# default["chef-server"]["configuration"]["api_fqdn"] = node["cloud_v2"]["public_hostname"] || "localhost"
