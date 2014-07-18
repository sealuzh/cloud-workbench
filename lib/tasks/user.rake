namespace :user do
  desc 'Create or update (if password has changed) the default user.'
  task create_default: :environment do
    default_email = Rails.application.config.default_email
    default_password = Rails.application.config.default_password
    Rake::Task['user:create'].invoke(default_email, default_password)
    # Alternative syntax
    # Rake.application.invoke_task("user:create[#{default_email}, #{default_password}]")
  end

  desc 'Create or update (if password has changed) a user with custom email and password.'
  task :create, [:email, :password] => [:environment]  do |task, args|
    create_or_update_user(args[:email], args[:password])
  end

  def create_or_update_user(email, new_password)
    user = User.find_or_create_by!(email: email)
    same_password = user.valid_password?(new_password)
    user.update!(password: new_password, password_confirmation: new_password) unless same_password
  end
end