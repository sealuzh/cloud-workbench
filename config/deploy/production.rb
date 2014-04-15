# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

set :stage, :production

server '33.33.33.66', roles: [:web, :app, :db], user: 'deploy', primary: true
set :deploy_to, "/home/apps/#{fetch(:application)}"
set :rails_env, "production"


# Custom SSH Options
# ==================
# See net/ssh documentation for other options: http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
set :ssh_options, {
   keys: %w(~/.ssh/id_rsa),
   forward_agent: true,
   auth_methods: %w(publickey)
}