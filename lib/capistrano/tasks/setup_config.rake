# frozen_string_literal: true

# Source: https://github.com/TalkingQuickly/capistrano-3-rails-template

namespace :deploy do
  task :setup_config do
    on roles(:app) do
      # make the config dir
      execute :mkdir, "-p #{shared_path}/config"
      full_app_name = fetch(:full_app_name)

      # config files to be uploaded to shared/config, see the
      # definition of smart_template for details of operation.
      # Essentially looks for #{filename}.erb in deploy/#{full_app_name}/
      # and if it isn't there, falls back to deploy/#{shared}. Generally
      # everything should be in deploy/shared with params which differ
      # set in the stage files. You may also specify two values of you
      # want to change the name
      # Example:
      # set(:config_files, [
      #   %w(database.secret.yml database.yml)  => 1)
      #   'userconfig.yml'                      => 2)
      # ])
      # folder := either 'shared' or "#{application_name}_#{stage}" (e.g. cloud_benchmarking_production)
      # 1) Will be copied from "config/deploy/#{folder}/database.secret.yml.erb" to "#{shared}/config/database.yml"
      # 2) Will be copied from "config/deploy/#{folder}/userconfig.yml.erb" to "#{shared}/config/userconfig.yml"
      config_files = fetch(:config_files) || Array.new
      config_files.each do |from, to = nil|
        smart_template from, to
      end

      # which of the above files should be marked as executable
      executable_files = fetch(:executable_config_files) || Array.new
      executable_files.each do |file|
        execute :chmod, "+x #{shared_path}/config/#{file}"
      end

      # symlink stuff which should be... symlinked
      symlinks = fetch(:symlinks) || Array.new
      symlinks.each do |symlink|
        sudo "ln -nfs #{shared_path}/config/#{symlink[:source]} #{sub_strings(symlink[:link])}"
      end
    end
  end
end
