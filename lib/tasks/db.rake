# frozen_string_literal: true

require 'pg'
namespace :db do
    # Fallbacks to Rails.env or production defaults if no arguments are provided
    # NOTICE: requires '' in zsh to prevent zsh pattern matching or escaping \[ \]
    desc 'Create or update (if password has changed) a PostgreSQL user. Example: `bin/rake \'db:create_user[myuser,mypw]\'`'
    task :create_user, [:username, :password] => [:environment]  do |task, args|
      username = args[:username] || db_config['username'] || db_config('production')['username']
      password = args[:password] || db_config['password'] || db_config('production')['password']
      create_or_update_db_user(username, password)
    end

    desc 'Drop a PostgreSQL user. Example: `bin/rake \'db:drop_user[myuser]\'`'
    task :drop_user, [:username] => [:environment]  do |task, args|
      username = args[:username] || db_config['username'] || db_config('production')['username']
      drop_db_user(username)
    end

    # Backup and restore based on: https://gist.github.com/hopsoft/56ba6f55fe48ad7f8b90#gistcomment-1646663
    desc 'Dump the database to backups using the format: c (custom), p (sql), t (tar), d (directory)'
    task :dump, [:format] => :environment do |task, args|
      dump_fmt = args[:format] || 'c'      # or 'p', 't', 'd'
      dump_sfx = suffix_for_format dump_fmt
      ensure_exists(backup_dir)
      file_name = formatted_timestamp + '_' + db_config['database'] + '.' + dump_sfx
      cmd = "#{pw_env} pg_dump #{username_arg} #{host_arg} #{dbname_arg} #{format_arg(dump_fmt)} --file=#{backup_dir}/#{file_name}"
      puts cmd
      system cmd
    end

    desc 'Show the existing database backups'
    task :list => :environment do
      puts "#{backup_dir}"
        Dir["#{backup_dir}/*[#{suffixes.join('|')}]"].sort.reverse.each { |x| puts File.basename(x) }
    end

    desc 'Restores the database from a backup using PATTERN'
    task :restore, [:pat] => :environment do |task, args|
      if args.pat.present?
        cmd = nil
        files = only_allowed_db_files(Dir.glob("#{backup_dir}/*#{args.pat}*"))
        case files.size
        when 0
          puts "No backups found for the pattern '#{args.pat}'"
        when 1
          file = files.first
            fmt = format_for_file(file)
            if fmt.nil?
              puts "No recognized dump file suffix: #{file}"
            elsif (fmt == 'p')
              cmd = "#{pw_env} psql #{username_arg} #{host_arg} #{dbname_arg} --file=#{file}"
            else
              cmd = "#{pw_env} pg_restore #{username_arg} #{host_arg} #{dbname_arg} --jobs=8 #{file}"
            end
          else
          puts "Too many files match the pattern '#{args.pat}':"
            puts ' ' + files.join("\n ")
            puts 'Try a more specific pattern'
        end
        unless cmd.nil?
          ENV['DISABLE_DATABASE_ENVIRONMENT_CHECK'] = '1'
          Rake::Task['db:drop'].invoke
          Rake::Task['db:create'].invoke
          puts cmd
          system cmd
          Rake::Task['db:migrate'].invoke
          Rake::Task['user:create_default'].invoke
        end
      else
        puts 'Please pass a pattern to the task'
      end
    end

    # Source: https://gist.github.com/mfilej/5943114
    desc "Fix 'database is being accessed by other users'"
    task :terminate => :environment do
      ActiveRecord::Base.connection.execute <<-SQL
        SELECT
          pg_terminate_backend(pid)
        FROM
          pg_stat_activity
        WHERE
          -- don't kill my own connection!
          pid <> pg_backend_pid()
          -- don't kill the connections to other databases
          AND datname = '#{ActiveRecord::Base.connection.current_database}';
      SQL
    end

    private

        # See: fs.rake
      def formatted_timestamp(time = Time.now)
        time.strftime('%Y-%m-%d-%H%M%S')
      end

        def pw_env
          "PGPASSWORD=#{db_config['password']}"
        end

        def username_arg
          "--username=#{db_config['username']}"
        end

        def dbname_arg
          "--dbname=#{db_config['database']}"
        end

        def host_arg
          "--host=#{db_config['host']}"
        end

        def format_arg(format)
          "--format=#{format}"
        end

        def create_or_update_db_user(username, password)
          con = PG.connect(dbname: 'postgres')
          res = con.exec("SELECT usename FROM pg_catalog.pg_user WHERE pg_user.usename='#{username}';")
          if (res.one?) # or res.num_tuples
            con.exec("ALTER ROLE #{username} WITH CREATEDB PASSWORD '#{password}';")
          else
            con.exec("CREATE ROLE #{username} WITH CREATEDB PASSWORD '#{password}';")
          end
        rescue => e
          STDERR.puts e
        ensure
          con.close if con
        end

        def drop_db_user(username)
          con = PG.connect(dbname: 'postgres')
          con.exec("DROP ROLE #{username};")
        rescue => e
          STDERR.puts e
        ensure
          con.close if con
        end

        def suffix_for_format suffix
          case suffix
          when 'c' then 'dump'
          when 'p' then 'sql' # TODO: Fix import because pg_restore does NOT support SQL alike-> sudo -u postgres psql -U postgres -d cloud_workbench_production -f dump.sql
          when 't' then 'tar'
          when 'd' then 'dir'
            else nil
          end
        end

        def format_for_file file
          case file
          when /\.dump$/ then 'c'
          when /\.sql$/  then 'p'
          when /\.dir$/  then 'd'
          when /\.tar$/  then 't'
            else nil
          end
        end

        def only_allowed_db_files(file_list)
          file_list.select do |file|
            end_with_any?(file, suffixes)
          end
        end

        def end_with_any?(string, suffixes)
          suffixes.map { |suffix| string.end_with?(suffix) }.include?(true)
        end

        def suffixes
          %w(.dump .sql .tar .dir)
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

        def db_config(rails_env = Rails.env)
          Rails.application.config.database_configuration[rails_env]
        end
  end
