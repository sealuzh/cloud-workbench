# frozen_string_literal: true

# Source: https://github.com/TalkingQuickly/capistrano-3-rails-template

namespace :nginx do
  %w(start stop restart reload).each do |task_name|
    desc "#{task_name} Nginx"
    task task_name do
      on roles(:app), in: :sequence, wait: 5 do
        sudo "/etc/init.d/nginx #{task_name}"
      end
    end
  end
end
