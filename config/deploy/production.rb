set :rails_env, :production # dont try and infer something as important as environment from stage name.
server '33.33.33.66', user: 'deploy', roles: %w{web app db}