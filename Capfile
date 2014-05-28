# Load DSL and Setup Up Stages
require 'capistrano/setup'

# See sv man pages for more commands: http://smarden.org/runit/sv.8.html
RUNIT_COMMANDS = %w(status up down once exit restart)

# Includes default deployment tasks
require 'capistrano/deploy'

# Includes tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#
# require 'capistrano/rvm'
# require 'rvm1/capistrano3'
require 'capistrano/rbenv'
# require 'capistrano/chruby'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/file-permissions'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/**/*.rb').each { |r| import r }
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
