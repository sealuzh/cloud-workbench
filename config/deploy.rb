# config valid only for Capistrano 3.1
lock '3.2.0'

set :application, "cloud_benchmarking"
set :repo_url,  "git@bitbucket.org:sealuzh/cloud-benchmarking.git"


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/apps/#{fetch(:application)}"

set :ssh_options, {
    keys: %w(~/.ssh/id_rsa),
    forward_agent: true,
    auth_methods: %w(publickey)
}

# Remote Server
# =============
set :use_sudo, false

# Bundler
# -------
set :bundle_flags, "--deployment --binstubs"
set :bundle_without, %w{development test}.join(' ')

# Rbenv
# -----
set :rbenv_path, '/opt/rbenv'
set :rbenv_ruby, File.read('.ruby-version').strip # Use ruby version from file
set :pty, true
BASH = '/bin/bash --login'
set :shell, BASH
set :default_shell, BASH

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  task :start do
    run "sudo sv up #{fetch(:application)}"
  end

  task :stop do
    run "sudo sv down #{fetch(:application)}"
  end

  desc "Restart application"
  task :restart do
    on roles(:app), :except => { :no_release => true } do
      run "sudo sv restart #{fetch(:application)}"
    end
  end

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after 'deploy:publishing', 'deploy:restart'

  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     # Your restart mechanism here, for example:
  #     # execute :touch, release_path.join('tmp/restart.txt')
  #   end
  # end
  #
  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end

end
