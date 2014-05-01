namespace :cron do
  desc 'Clear the generated system cron schedules.'
  task clean: :environment do
    BenchmarkSchedule.clear_system_crontab
  end
end

# Clean the cron schedule on db:drop for non-production environments.
Rake::Task['db:drop'].enhance do
  Rake::Task['cron:clean'].invoke unless Rails.env.production?
end