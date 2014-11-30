set :rails_env, :production # dont try and infer something as important as environment from stage name.
server '33.33.33.20', user: 'deploy', roles: %w{web app db}
set :delayed_job_workers, 2
# set :branch, 'branch-name'

namespace :deploy do
  after 'deploy:restart', :create_default_user do
    remote_rake('user:create_default') # Configure default password in 'config/application.rb'
  end
end