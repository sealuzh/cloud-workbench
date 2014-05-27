set :rails_env, :production # dont try and infer something as important as environment from stage name.
server '176.34.93.33', user: 'deploy', roles: %w{web app db}
set :delayed_job_workers, 2
set :branch, 'stabilization-testing'