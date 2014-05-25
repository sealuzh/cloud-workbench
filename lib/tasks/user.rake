namespace :user do
  desc 'Create a default user.'
  task create_default: :environment do
    default_email = Rails.application.config.default_email
    default_password = Rails.application.config.default_password
    Rake::Task['user:create'].invoke(default_email, default_password)
    # Alternative syntax
    # Rake.application.invoke_task("user:create[#{default_email}, #{default_password}]")
  end

  desc 'Create a user with custom email and password.'
  task :create, [:email, :password] => [:environment]  do |task, args|
    User.create(email: args[:email], password: args[:password], password_confirmation: args[:password])
  end
end