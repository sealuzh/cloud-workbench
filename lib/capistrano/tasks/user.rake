
namespace :user do
  desc "Change the password for the default user: 'cap demo user:change[new_password]'"
  task :change, :password, :environment do |task, args|
    on primary(:app) do
      within current_path do
        with :rails_env => fetch(:rails_env) do
          default_email = 'seal@uzh.ch' # TODO: Fix hardcoded value (MUST match with application.rb)
          # NOTE: Rails environment is not available here
          # default_email = Rails.application.config.default_email
          # default_password = Rails.application.config.default_password
          remote_rake("user:create[#{default_email},#{args[:password]}]")
        end
      end
    end
  end

  # Executes a rake task on the primary app within the correct path within the full Rails environment
  def remote_rake(task)
    on primary(:app) do
      within current_path do
        with :rails_env => fetch(:rails_env) do
          rake task
        end
      end
    end
  end
end
