namespace :unicorn do
  # Example: 'cap production unicorn:status'
  RUNIT_COMMANDS.each do |task_name|
    desc "#{task_name} #{fetch(:application)}"
    task task_name do
      on roles(:app), in: :sequence, wait: 5 do
        sudo "sv #{task_name} #{fetch(:application)}"
      end
    end
  end
end