set :rails_env, :production # dont try and infer something as important as environment from stage name.
server 'CWB_SERVER_IP', user: 'deploy', roles: %w{web app db}
set :delayed_job_workers, 8