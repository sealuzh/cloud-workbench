require 'fileutils'
namespace :fs do
  desc 'Clean the file system by removing the generated files (e.g. Vagrantfile, logs)'
  task clean: :environment do
    clean_storage_dir
  end

  def clean_storage_dir
    FileUtils.rm_rf(Dir[Rails.application.config.storage])
  end
end

# Clean the file system on db:drop for non-production environments.
Rake::Task['db:drop'].enhance do
  Rake::Task['fs:clean'].invoke unless Rails.env.production?
end