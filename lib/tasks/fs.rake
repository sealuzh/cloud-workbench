require 'fileutils'

namespace :fs do
  desc 'Clean the file system by removing the generated files (e.g. Vagrantfile)'
  task clean: :environment do
    # TODO: Define file system paths in a single configuration => no duplication!
    FileUtils.rm_rf(Dir[Rails.root.join('public/benchmark_definitions')])
  end
end

# Clean the file system on db:drop for non-production environments.
Rake::Task['db:drop'].enhance do
  Rake::Task['fs:clean'].invoke unless Rails.env.production?
end