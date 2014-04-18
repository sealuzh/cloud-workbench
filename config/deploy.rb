# config valid only for Capistrano 3.1
lock '3.2.0'

set :application, 'cloud_benchmarking'
set :repo_url,  'git@bitbucket.org:sealuzh/cloud-benchmarking.git'
# Used in case we're deploying multiple versions of the same app side by side.
# Also provides quick sanity checks when looking at filepaths.
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

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
# Ensure that your web server is configured to use vendor/bundle as bundle path.
# You may need to configure the BUNDLE_PATH environment variable or web server specific settings.
set :bundle_path, -> { shared_path.join('vendor/bundle') }
set :bundle_flags, '--deployment --binstubs'
set :bundle_without, %w{development test}.join(' ')

# Rbenv
# -----
set :rbenv_path, '/opt/rbenv'
set :rbenv_ruby, File.read('.ruby-version').strip # Use ruby version from file
set :pty, true
BASH = '/bin/bash --login'
set :shell, BASH
set :default_shell, BASH


# Custom test task extension: what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, []

# Default value for :log_level is :debug
# set :log_level, :debug

# which config files should be copied by deploy:setup_config
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
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/benchmark_definitions}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  # Make sure we're deploying what we think we're deploying
  before :deploy, 'deploy:check_revision'
  # Only allow a deploy with passing tests to deployed
  before :deploy, 'deploy:run_tests'

  # compile assets locally then rsync
  # after 'deploy:symlink:shared', 'deploy:compile_assets_locally'

  # As of Capistrano 3.1, the `deploy:restart` task is not called automatically.
  after 'deploy:publishing', 'deploy:restart'

  after :finishing, 'deploy:cleanup'


  task :start do
    execute "sudo sv up #{fetch(:application)}"
    # execute :rake, "jobs:work"
  end

  task :stop do
    execute "sudo sv down #{fetch(:application)}"
  end

  # See Capistrano docs: http://capistranorb.com/2013/06/01/release-announcement.html
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo sv restart #{fetch(:application)}"
      # TODO: Create runit configuration for Delayed_job workers
      # execute :rake, "jobs:work"
    end
  end
end
