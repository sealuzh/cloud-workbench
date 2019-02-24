# frozen_string_literal: true

namespace :cron do
  desc 'Clean system crontab.'
  task :clean do
    # Workaround for failure on initial (i.e. first) deployment since no checkout is present yet.
    begin
      cron_task('clean')
    rescue => e
      puts "WARNING: Could not execute 'cron:clean'. Ignore this waring if this is the first deployment. #{e.message}"
    end
  end

  desc 'Reflect the Cron schedules from database in system cron.'
  task :update do
    cron_task('update')
  end

  def cron_task(task)
    rake_task_as_user("cron:#{task}", fetch(:apps_user))
  end

  # NOTE: This is a workaround to run a rake task as another user since the
  # Capistrano feature "as :user do ... end" fails in combination with rbenv.
  # The environment variables will not be passed correctly (i.e., to the inner command) as shown by this example:
  # Would result in: "cd /home/apps/cloud_benchmarking/current && ( RBENV_ROOT=/opt/rbenv RBENV_VERSION=2.1.1 RAILS_ENV=production sudo su apps -c "/usr/bin/env printenv" )"
  def rake_task_as_user(task, user)
    on primary(:app) do
      command = manual_rake(task)
      execute command_as_user(command, user)
    end
  end

  def manual_rake(task)
    dir = release_path
    env = "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} RAILS_ENV=#{fetch(:rails_env)}"
    bin = "#{fetch(:rbenv_path)}/bin/rbenv exec bundle exec rake"
    "cd #{dir} && ( #{env} #{bin} #{task} )"
  end

  def command_as_user(command, user)
    "sudo su #{user} -c \"#{command}\""
  end
end
