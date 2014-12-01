# For further options see: http://docs.opscode.com/config_rb_knife.html

# TODO:
# 1. Update CHEF_SERVER and REPO_ROOT
# 2. Copy this file to ~/.chef/knife.rb

# MUST match with what is configured as api_fqdn on the chef-server (either IP or FQDN)
CHEF_SERVER = 'A.B.C.D'
# Path to git repository
REPO_ROOT = '~/git/cloud-workbench'
# Install provider (name of the install directory)
PROVIDER = 'aws'


CHEF_REPO = "#{REPO_ROOT}/chef-repo"
SECRETS_DIR    = "#{REPO_ROOT}/install/#{PROVIDER}"
SITE_COOKBOOKS = "#{CHEF_REPO}/site-cookbooks"
COOKBOOKS      = "#{CHEF_REPO}/cookbooks"

log_level                :info
log_location             STDOUT
node_name                'cwb-server'
client_key               "#{SECRETS_DIR}/chef_client_key.pem"
validation_client_name   'chef-validator'
validation_key           "#{SECRETS_DIR}/chef_validator.pem"
chef_server_url          "https://#{CHEF_SERVER}:443"
syntax_check_cache_path  '~/.chef/syntax_check_cache'
cookbook_path [ SITE_COOKBOOKS,
                COOKBOOKS
              ]

knife[:download_directory] = COOKBOOKS
