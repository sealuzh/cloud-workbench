# frozen_string_literal: true

namespace :unicorn do
  # Example: 'cap production unicorn:status'
  RUNIT_COMMANDS.each do |task_name|
    desc "#{task_name} unicorn"
    task task_name do
      on roles(:app), in: :sequence do
        sudo "sv #{task_name} #{fetch(:application)}"
      end
    end
  end
end