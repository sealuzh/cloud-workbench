# frozen_string_literal: true

namespace :user do
  desc 'Create or update (if password has changed) the default user.'
  task create_default: :environment do
    default_email = Rails.application.config.default_email
    default_password = Rails.application.config.default_password
    Rake::Task['user:create'].invoke(default_email, default_password)
    # Alternative syntax
    # Rake.application.invoke_task("user:create[#{default_email}, #{default_password}]")
  end

  # NOTICE: ZSH users might need to escape [ and ] (i.e, '\[' and '\]') or enclose with single quotes (i.e., `'rake user:create[myemail,mypw]'`)
  desc 'Create or update (if password has changed) a user with optional email and password args. Example: `rake user:create[myemail,mypw]`'
  task :create, [:email, :password] => [:environment]  do |task, args|
    email = args[:email] || Rails.application.config.default_email
    password = args[:password] || Rails.application.config.default_password
    create_or_update_user(email, password)
  end

  private

    def create_or_update_user(email, new_password)
      user = User.find_or_create_by!(email: email)
      same_password = user.valid_password?(new_password)
      user.update!(password: new_password, password_confirmation: new_password) unless same_password
    end
end
