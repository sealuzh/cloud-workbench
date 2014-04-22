set :rails_env, :production # dont try and infer something as important as environment from stage name.
server '46.137.2.62', user: 'deploy', roles: %w{web app db}