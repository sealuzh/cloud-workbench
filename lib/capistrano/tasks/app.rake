namespace :app do
  # See sv man pages for more commands: http://smarden.org/runit/sv.8.html
  %w(status up down once exit restart).each do |task_name|
    desc "#{task_name} #{fetch(:application)}"
    task task_name do
      on roles(:app), in: :sequence, wait: 5 do
        sudo "sv #{task_name} #{fetch(:application)}"
      end
    end
  end
end