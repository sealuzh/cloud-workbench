set :rails_env, :production # dont try and infer something as important as environment from stage name.
server '54.228.71.158', user: 'deploy', roles: %w{web app db}