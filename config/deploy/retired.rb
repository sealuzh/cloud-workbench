set :rails_env, :production # dont try and infer something as important as environment from stage name.
server '54.75.76.223', user: 'deploy', roles: %w{web app db}
set :delayed_job_workers, 4
# set :branch, 'branch-name'
