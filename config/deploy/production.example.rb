# See deploy.rb for more options
set :rails_env, :production # dont try and infer something as important as environment from stage name.
server 'CWB_SERVER_IP', user: 'deploy', roles: %w{web app db}
set :delayed_job_workers, 2

# Manually assign a new password via 'cap production user:change[new_password]'
# Automatically create a default password `demo` (configurable in config/application.rb)
namespace :deploy do
  after 'deploy:restart', :create_default_user do
    remote_rake('user:create_default')
  end
end

# Update SSH settings on demand (only for private repositories)
# set :ssh_options, {
#     keys: %w(~/.ssh/id_rsa),  <== private ssh key path
#     forward_agent: true,
#     auth_methods: %w(publickey)
# }
