# frozen_string_literal: true

# Capistrano 3 announcements: http://capistranorb.com/2013/06/01/release-announcement.html
# Capistrano 3 docs: https://github.com/capistrano/capistrano
# For path helpers see: 'Capistrano::DSL::Paths' in capistrano/lib/capistrano/dsl/paths.rb

# Capistrano
# ----------
# Config valid only for specific Capistrano version
lock '3.2.1'
set :log_level, :debug
set :format, :pretty

# Application
# -----------
set :application, 'cloud_benchmarking'
# Used in case we're deploying multiple versions of the same app side by side.
# Also provides quick sanity checks when looking at filepaths.
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :delayed_job_workers, 1
set :live, false

# Repository
# ----------
set :repo_url, 'https://github.com/sealuzh/cloud-workbench.git'
set :branch, 'master'

# SSH connection
# --------------
set :ssh_options, {
    keys: %w(~/.ssh/id_rsa),
    forward_agent: true,
    auth_methods: %w(publickey)
}

# Remote machine
# --------------
set :deploy_to, "/home/apps/#{fetch(:application)}"
set :deploy_user, 'deploy'
set :apps_user, 'apps'
set :keep_releases, 5
set :use_sudo, false

# Defines which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations. Provide two values if you want
# to rename e.g. 'database.secret.yml' to 'database.yml'
# These files will be copied to "#{shared}/config"
set(:config_files, [
    %w(database.secret.yml database.yml)
])

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system storage chef-repo}

# File system permissions:
# the application and background workers must be able to read and write to the logs and storage directory
set :file_permissions_paths, %w(log log/production.log storage)
set :file_permissions_users, ["#{fetch(:apps_user)}"]

# Bundler
# -------
# Ensure that your web server is configured to use vendor/bundle as bundle path.
# You may need to configure the BUNDLE_PATH environment variable or web server specific settings.
set :bundle_path, -> { shared_path.join('vendor/bundle') }
set :bundle_flags, '--deployment --binstubs'
set :bundle_without, %w{development test chef deployment}.join(' ')

# Rbenv
# -----
set :rbenv_path, '/opt/rbenv'
set :rbenv_ruby, File.read('.ruby-version').strip # Use ruby version from file

# Shell
# -----
set :pty, true
BASH = '/bin/bash --login'
set :shell, BASH
set :default_shell, BASH

# Tests
# -----
# Custom test task extension: what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, []

# Deploy tasks
# ============
# Live deploy via: "cap production deploy live=true"
namespace :deploy do
  unless ENV['live'].to_s.empty?
    set :live, ( ENV['live'].to_s == 'true' ? true : false )
  end
  # Make sure we're deploying what we think we're deploying
  # before :deploy, 'deploy:check_revision'
  # Only allow a deploy with passing tests to deployed
  # before :deploy, 'deploy:run_tests'
  before 'deploy', 'cron:clean'
  # Compile assets locally then rsync. Enable if you want to burden assets compilation to the production server.
  # after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  # Set file system permissions
  after 'deploy:publishing', 'deploy:set_permissions:acl'
  # As of Capistrano 3.1, the `deploy:restart` task is not called automatically.
  after 'deploy:publishing', 'deploy:restart', 'live'
  after :finishing, 'deploy:cleanup'
  after :deploy, 'cron:update'

  # Includes: Unicorn, delayed_job workers and system cron management (nginx and postgres are not considered here)
  desc 'Restart application and workers'
  task :restart do |task, args|
    on roles(:app), in: :sequence do
      invoke 'unicorn:restart'
      # TODO: Think about graceful restart for running jobs: e.g. schedule restart as job does not work with multiple workers
      # NOTE: Deployment or jobs may fail if there are workers that currently process some jobs.
      invoke 'worker:restart_all' unless fetch(:live)
    end
  end

  desc 'Clean system crontab.'
  task :clear_cron do
    invoke 'cron:clean'
  end

  desc 'Reflect the Cron schedules from database in system cron.'
  task :update_cron do
    invoke 'cron:update'
  end

  desc 'Restart all delayed_job background workers'
  task :restart_workers do
    invoke 'worker:restart_all'
  end

  desc 'Start application, workers, and scheduler.'
  task :start do
    invoke 'cron:clean'
    invoke 'unicorn:up'
    invoke 'worker:up_all'
    invoke 'cron:update'
  end

  desc 'Stop scheduler, workers, and application.'
  task :stop do
    invoke 'cron:clean'
    invoke 'worker:down_all'
    invoke 'unicorn:down'
  end
end

# Executes a rake task on the primary app within the correct path within the full Rails environment
def remote_rake(task)
  on primary(:app) do
    within current_path do
      with rails_env: fetch(:rails_env) do
        rake task
      end
    end
  end
end
