# frozen_string_literal: true

DEFAULT_COMMAND = 'about'
desc "Invoke a rake command on the remote app server: 'cap production rake[about]'"
task :rake, :command do |task, args|
  on primary(:app) do
    within current_path do
      with :rails_env => fetch(:rails_env) do
        rake ( args[:command] || DEFAULT_COMMAND )
      end
    end
  end
end