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
    desc "Dump the database to backups"
    task :dump => :environment do
      dump_fmt = 'c'      # or 'p', 't', 'd'
      dump_sfx = suffix_for_format dump_fmt
      ensure_exists(backup_dir)
      file_name = Time.now.strftime("%Y%m%d%H%M%S") + "_" + db_config['database'] + '.' + dump_sfx
      cmd = "pg_dump -F #{dump_fmt} -v -h #{db_config['host']} -d #{db_config['database']} -f #{backup_dir}/#{file_name}"
      puts cmd
      system cmd
    end

    desc "Show the existing database backups"
    task :list => :environment do
        # puts "#{backup_dir}"
        Dir["#{backup_dir}/*[#{suffixes.join('|')}]"].each { |x| puts File.basename(x) }
    end

    desc "Restores the database from a backup using PATTERN"
    task :restore, [:pat] => :environment do |task, args|
      if args.pat.present?
        cmd = nil
        files = Dir.glob("#{backup_dir}/*#{args.pat}*")
        case files.size
          when 0
            puts "No backups found for the pattern '#{args.pat}'"
          when 1
            file = files.first
            fmt = format_for_file file
            if fmt.nil?
              puts "No recognized dump file suffix: #{file}"
            else
              cmd = "pg_restore -F #{fmt} -v -c -C #{file}"
            end
          else
            puts "Too many files match the pattern '#{args.pat}':"
            puts ' ' + files.join("\n ")
            puts "Try a more specific pattern"
        end
        unless cmd.nil?
          Rake::Task["db:drop"].invoke
          Rake::Task["db:create"].invoke
          puts cmd
          system cmd
        end
      else
        puts 'Please pass a pattern to the task'
      end
    end

    private

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
            when 'p' then 'sql'
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

        def db_config(rails_env=Rails.env)
          Rails.application.config.database_configuration[rails_env]
        end
  end
