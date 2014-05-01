namespace :cron do
  desc 'Clear the generated system cron benchmark schedules.'
  task clean: :environment do
    BenchmarkSchedule.clear_system_crontab
  end

  desc 'Update the generated system cron benchmark schedules.'
  task update: :environment do
    BenchmarkSchedule.update_system_crontab
  end
end

# Clean the cron schedule on db:drop for non-production environments.
Rake::Task['db:drop'].enhance do
  Rake::Task['cron:clean'].invoke unless Rails.env.production?
end