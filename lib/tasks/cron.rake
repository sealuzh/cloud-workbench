# frozen_string_literal: true

# NOTE: Make sure that you run these tasks as the right user!
namespace :cron do
  desc 'Clear the generated Cron benchmark schedules (user dependent!).'
  task clean: :environment do
    BenchmarkSchedule.clear_system_crontab
  end

  desc 'Update the generated Cron benchmark schedules (user dependent!).'
  task update: :environment do
    BenchmarkSchedule.update_system_crontab
  end
end

# Clean the cron schedule on db:drop
Rake::Task['db:drop'].enhance do
  Rake::Task['cron:clean'].invoke
end