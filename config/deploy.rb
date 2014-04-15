# config valid only for Capistrano 3.2
lock '3.2.0'

set :application, "cloud_benchmarking"
# set :repo_url,  "git@bitbucket.org:sealuzh/cloud-benchmarking.git"

# Deploy from local repo
set :scm, :none
set :repository, "."
set :deploy_via, :copy

set :branch, "master"
set :keep_releases, 5

# Use with git repo later
# Code Repository
# =========
# set :scm, :git
# set :scm_verbose, true
# set :deploy_via, :remote_cache

# Remote Server
# =============
set :use_sudo, false

# Bundler
# -------
set :bundle_flags, "--deployment --binstubs"
set :bundle_without, [:test, :development, :deploy]

# Rbenv
# -----
set :pty, true
BASH = '/bin/bash --login'
set :shell, BASH
set :default_shell, BASH

# Rails: Asset Pipeline
# ---------------------
# load 'deploy/assets' # Does not work with Capistrano 3

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"
# after :finishing, "deploy:cleanup"




# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

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

  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     # Your restart mechanism here, for example:
  #     # execute :touch, release_path.join('tmp/restart.txt')
  #   end
  # end
  #
  # after :publishing, :restart
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
