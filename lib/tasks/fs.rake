require 'fileutils'
require 'pathname'

# Clean the file system on db:drop for non-production environments.
Rake::Task['db:drop'].enhance do
  Rake::Task['fs:clean'].invoke unless Rails.env.production?
end

namespace :fs do
  desc 'Dump the file system by compressing the generated files (e.g. Vagrantfile, logs)'
  task dump: :environment do
    ensure_exists(backup_dir)
    dest = File.join(backup_dir, file_name(Time.now))
    cmd = "tar -czf #{dest} -C #{File.dirname(storage_dir)} #{File.basename(storage_dir)}"
    puts cmd
    system cmd
  end

  desc "Show the existing file system backups"
  task :list => :environment do
      puts "#{backup_dir}"
      Dir["#{backup_dir}/*#{file_extension}"].sort.reverse.each { |x| puts File.basename(x) }
  end

  desc 'Restore the file system by uncompressing the compressed generated files'
  task :restore, [:pat] => :environment do |task, args|
    if args.pat.present?
      cmd = nil
      files = only_allowed_fs_files(Dir.glob("#{backup_dir}/*#{args.pat}*"))
      case files.size
        when 0
          puts "No backups found for the pattern '#{args.pat}'"
        when 1
          file = files.first
          if file.end_with?(file_extension)
            cmd = "tar xf #{file} -C #{File.dirname(storage_dir)}"
          else
            puts "No recognized dump file suffix: #{file}"
          end
        else
          puts "Too many files match the pattern '#{args.pat}':"
          puts ' ' + files.join("\n ")
          puts "Try a more specific pattern"
      end
      unless cmd.nil?
        Rake::Task["fs:clean"].invoke
        puts cmd
        system cmd
      end
    else
      puts 'Please pass a pattern to the task'
    end
  end

  desc 'Clean the file system by removing the generated files (e.g. Vagrantfile, logs)'
  task clean: :environment do
    clean_storage_dir
  end

  private

      def clean_storage_dir
        FileUtils.rm_rf(Dir[storage_dir])
      end

      def storage_dir
        Rails.application.config.storage
      end

      def file_name(time)
        formatted_timestamp(time) + '_' + db_config['database'] + file_extension
      end

      # See: db.rake
      def formatted_timestamp(time = Time.now)
        time.strftime("%Y-%m-%d-%H%M%S")
      end

      def file_extension
        '.tar.gz'
      end

      def ensure_exists(dir)
        unless Dir.exist?(dir)
          puts "Creating #{backup_dir} .."
          Dir.mkdir(backup_dir)
        end
      end

      def backup_dir
        "#{Rails.root}/db/backups"
      end

      def db_config
        Rails.configuration.database_configuration[Rails.env]
      end

      def only_allowed_fs_files(file_list)
        file_list.select do |file|
          file.end_with?(file_extension)
        end
      end
end
