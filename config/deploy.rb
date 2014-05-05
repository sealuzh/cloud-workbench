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

# Repository
# ----------
set :repo_url, 'git@bitbucket.org:sealuzh/cloud-benchmarking.git'
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
# TODO: Use "#{Rails.root}/storage" (and symlink it) to store your files. Follow the advices here: http://makandracards.com/makandra/16999-common-mistakes-when-storing-file-uploads-with-rails
# Also consider the following alternatives:
# * Store the Vagrantfile in the database and create the file when creating a benchmark execution.
# * Use Paperclip and Carrierwave to manage attachments
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system storage chef-repo}

# Bundler
# -------
# Ensure that your web server is configured to use vendor/bundle as bundle path.
# You may need to configure the BUNDLE_PATH environment variable or web server specific settings.
set :bundle_path, -> { shared_path.join('vendor/bundle') }
set :bundle_flags, '--deployment --binstubs'
set :bundle_without, %w{development test chef}.join(' ')

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
namespace :deploy do
  # Make sure we're deploying what we think we're deploying
  before :deploy, 'deploy:check_revision'
  # Only allow a deploy with passing tests to deployed
  before :deploy, 'deploy:run_tests'
  # Compile assets locally then rsync. Enable if you want to burden assets compilation to the production server.
  # after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  # As of Capistrano 3.1, the `deploy:restart` task is not called automatically.
  after 'deploy:publishing', 'deploy:restart'
  after :finishing, 'deploy:cleanup'


  # The declarative approach does not work with the custom rake task.
  # Even using the fully qualified name did not resolve this issue:
  # https://github.com/capistrano/capistrano/issues/959
  # before :'deploy:restart', :'rake[cron:clean]'
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # invoke 'rake[cron:clean]'
      # Rake::Task['cron:clean'].invoke
      execute "sudo sv restart #{fetch(:application)}"
      # TODO: Be aware that this will abort the delayed job worker!
      execute 'sudo sv restart delayed_job'
    end
  end

  desc 'Restart the delayed job background worker'
  task :restart_worker do
    # TODO: Think about graceful restart for running jobs: e.g. schedule restart as job does not work with multiple workers
    execute 'sudo sv restart delayed_job'
  end

  task :start do
    # invoke 'rake[cron:clean]'
    execute "sudo sv up #{fetch(:application)}"
    execute 'sudo sv up delayed_job'
    # invoke 'rake[cron:update]'
  end

  task :stop do
    # invoke 'rake[cron:clean]'
    execute "sudo sv down #{fetch(:application)}"
    execute 'sudo sv down delayed_job'
  end
end
