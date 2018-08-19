namespace :data do
  desc 'Backup database and file storage'
  task backup: :environment do
    Rake::Task["db:dump"].invoke
    Rake::Task["fs:dump"].invoke
  end

  desc 'List database and file storage backups'
  task list: :environment do
    Rake::Task["db:list"].invoke
    Rake::Task["fs:list"].invoke
  end

  desc 'Restore database and file storage'
  task :restore, [:pat] => :environment do |task, args|
    Rake::Task['db:restore'].invoke(args.pat)
    Rake::Task['fs:restore'].invoke(args.pat)
  end
end
