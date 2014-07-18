# See deploy.rb for more options
set :rails_env, :production # dont try and infer something as important as environment from stage name.
server '54.220.85.48', user: 'deploy', roles: %w{web app db}
set :delayed_job_workers, 2

namespace   :deploy do
  after 'deploy:restart', :create_default_user do
    remote_rake('user:create_default') # Configure default password in 'config/application.rb'
  end
end

# Update SSH settings on demand
# set :ssh_options, {
#     keys: %w(~/.ssh/id_rsa),  <== private ssh key path
#     forward_agent: true,
#     auth_methods: %w(publickey)
# }

# Executes a rake task on the primary app within the correct path within the full Rails environment
def remote_rake(task)
  on primary(:app) do
    within current_path do
      with :rails_env => fetch(:rails_env) do
        rake task
      end
    end
  end
end
