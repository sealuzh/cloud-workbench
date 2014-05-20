# Source: https://github.com/TalkingQuickly/capistrano-3-rails-template

namespace :logs do
  # Example: 'cap production logs:tail[production]'
  task :tail, :file do |task, args|
    if args[:file]
      on roles(:app) do
        execute "tail -f #{shared_path}/log/#{args[:file]}.log"
      end
    else
      print_usage
    end
  end

  def print_usage
    puts "please specify a logfile e.g: 'cap production logs:tail[production]"
    puts "will tail 'shared_path/log/logfile.log'"
    puts "remember if you use zsh you'll need to format it as:"
    puts "cap production logs:tail[production]' (single quotes)"
  end
end
