require 'pg'
namespace :db do
    # Fallbacks to Rails.env or production defaults if no arguments are provided
    # NOTICE: requires '' in zsh to prevent zsh pattern matching or escaping \[ \]
    desc 'Create or update (if password has changed) a PostgreSQL user. Example: `bin/rake \'db:create_user[myuser,mypw]\'`'
    task :create_user, [:username, :password] => [:environment]  do |task, args|
      db_config = Rails.application.config.database_configuration[Rails.env]
      db_prod_config = Rails.application.config.database_configuration['production']
      username = args[:username] || db_config['username'] || db_prod_config['username']
      password = args[:password] || db_config['password'] || db_prod_config['password']
      create_or_update_db_user(username, password)
    end

    desc 'Drop a PostgreSQL user. Example: `bin/rake \'db:drop_user[myuser]\'`'
    task :drop_user, [:username] => [:environment]  do |task, args|
      db_config = Rails.application.config.database_configuration[Rails.env]
      db_prod_config = Rails.application.config.database_configuration['production']
      username = args[:username] || db_config['username'] || db_prod_config['username']
      drop_db_user(username)
    end

    desc 'Create the PostgreSQL database'
    task create_db: :environment do
        db_config = Rails.application.config.database_configuration[Rails.env]
        create_db(db_config['database'])
    end

    private

        def create_or_update_db_user(username, password)
          con = PG.connect(dbname: 'postgres')
          res = con.exec("SELECT usename FROM pg_catalog.pg_user WHERE pg_user.usename='#{username}';")
          if (res.one?) # or res.num_tuples
            con.exec("ALTER USER #{username} WITH CREATEDB PASSWORD '#{password}';")
          else
            con.exec("CREATE USER #{username} WITH CREATEDB PASSWORD '#{password}';")
          end
        rescue => e
          STDERR.puts e
        ensure
          con.close if con
        end

        def drop_db_user(username)
          con = PG.connect(dbname: 'postgres')
          con.exec("DROP USER #{username};")
        rescue => e
          STDERR.puts e
        ensure
          con.close if con
        end

        def create_db(db_name)
          con = PG.connect(dbname: 'postgres')
          con.exec("CREATE DATABASE #{db_name};")
        rescue => e
          STDERR.puts e
        ensure
          con.close if con
        end
  end
