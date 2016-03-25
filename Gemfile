source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Import Gemfile that handles tooling (i.e. Chef and deployment)
# GEMFILE = File.join(File.dirname(__FILE__), 'Gemfile.tools')
# Dir.glob(GEMFILE) do |gemfile|
#     eval(IO.read(gemfile), binding)
# end

gem 'rails', '4.2.6'

# General
# NOTE: This gem is not thread-safe and SHOULD NOT be used with
#       threaded web servers such as puma. It is used to suppress
#       the logs of polling javascript
gem 'silencer', '~> 0.6.0'
gem 'whenever', '~> 0.9.2'
gem 'cron2english', '~> 0.1.3'
gem 'delayed_job_active_record', '~> 4.1'
gem 'enumerize', '~> 1.1.1'
gem 'deep_cloneable', '~> 2.2.0'
gem 'devise', '~> 3.5' # Authentication

# Assets
gem 'therubyracer', '~> 0.12.2', platforms: :ruby
gem 'less-rails', '~> 2.7'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'coffee-rails', '~> 4.1.1'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 2.4'

## UI
gem 'font-awesome-rails', '~> 4.5.0.1'
gem 'will_paginate', '~> 3.1.0'
gem 'bootstrap-will_paginate', '~> 0.0.10'
gem 'simple_form', '~> 3.2.1'
gem 'data-confirm-modal', github: 'ifad/data-confirm-modal'

# Admin
gem 'pry'
gem 'pry-rails' # Use pry as Rails console

group :production do
  gem 'unicorn'
  gem 'pg'
  gem 'execjs'
end

group :development do
  gem 'thin'
  gem 'spring'
  # Easy way to support `readline` for Guard and Pry:
  # https://github.com/guard/guard/wiki/Add-Readline-support-to-Ruby-on-Mac-OS-X
  gem 'rb-readline'
  gem 'pry-byebug' # Use pry as debugger with step, next, finish, continue
  gem 'launchy'
  gem 'guard-livereload', require: false
  gem 'rack-livereload'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'quiet_assets'
end

OPTIONAL=false
if OPTIONAL
  # Visualize dependency graph `bundle viz` (requires `graphviz`)

  # Install `gem install metric_fu`
  # Analyze `metric_fu`
  # Docs at https://github.com/metricfu/metric_fu/
  group :development do
    # UML class diagram creator
    # Requires `graphviz`
    # Generate `rake diagram:all`
    # Docs at https://github.com/preston/railroady
    gem 'railroady'
  end
end

group :development, :test do
  gem 'sqlite3'
  gem 'faker'
  gem 'rspec-rails', '~> 3.4.2'
  gem 'rspec-its' # Support for deprecated `its` syntax in RSpec 3
  gem 'fuubar' # RSpec progress bar formatter
  gem 'spring-commands-rspec'
  gem 'guard' # NOTE: this is necessary in newer versions
  gem 'guard-rspec'
  gem 'simplecov', require: false
end

group :test do
  gem 'capybara', '~> 2.6.2'
  gem 'database_cleaner', '~> 1.5.0'
  gem 'factory_girl_rails', '~> 4.6'
end

group :doc do
  # Generate docs with `yard doc`
  # Docs at http://www.rubydoc.info/gems/yard/
  gem 'yard', '~> 0.8.7.6', require: false
end
