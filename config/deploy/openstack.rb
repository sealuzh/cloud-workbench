set :rails_env, :production # dont try and infer something as important as environment from stage name.
server '128.130.172.195', user: 'deploy', roles: %w{web app db}
set :delayed_job_workers, 8