source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Import Gemfile that handles tooling (i.e. Chef and deployment)
# GEMFILE = File.join(File.dirname(__FILE__), 'Gemfile.tools')
# Dir.glob(GEMFILE) do |gemfile|
#     eval(IO.read(gemfile), binding)
# end

gem 'rails', '4.2.6'

# NOTE: This gem is not thread-safe and SHOULD NOT be used with
#       threaded web servers such as puma. It is used to suppress
#       the logs of polling javascript
gem 'silencer', '~> 0.6.0'
gem 'whenever', '~> 0.9.2'
gem 'cron2english', '~> 0.1.3'
gem 'delayed_job_active_record', '~> 4.1'
gem 'enumerize', '~> 1.1.1'
gem 'deep_cloneable', '~> 2.2.0'
gem 'devise', '~> 3.5', '>= 3.5.6'

gem 'pry'
gem 'pry-rails' # Use pry as Rails console

group :development do
  gem 'thin'
  gem 'pry-byebug' # Use pry as debugger with step, next, finish, continue
  gem 'launchy'
  gem 'guard-livereload', require: false
  gem 'rack-livereload'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'quiet_assets'
  gem 'rb-readline' # Fixes guard issues with interactive pry
  gem 'railroady' # UML class diagram creator
end

group :development, :test do
  gem 'sqlite3'
  gem 'faker'
  gem 'rspec-rails', '~> 2.99'
  gem 'fuubar' # RSpec progress bar formatter
  gem 'guard' # NOTE: this is necessary in newer versions
  gem 'guard-rspec', '~> 4.6.4'
  gem 'simplecov', require: false

  gem 'spork-rails', '~> 4.0.0'
  gem 'guard-spork', '~> 2.1'
  gem 'childprocess', '~> 0.5.3'
end

group :test do
  gem 'capybara', '~> 2.6.2'
  gem 'selenium-webdriver', '~> 2.41.0'
  gem 'database_cleaner', '~> 1.5.0'
  gem 'factory_girl_rails', '~> 4.6'

  ## For Guard notifications:
  # Uncomment this line on OS X.
  # gem 'growl', '~> 1.0.3'

  # Uncomment these lines on Linux.
  # gem 'libnotify', '~> 0.8.2'

  # Uncomment these lines on Windows.
  # gem 'rb-notifu', '0.0.4'
  # gem 'wdm', '0.1.0'
end

# Uncomment and run bundle install for installation
# or install with 'gem install metric_fu'.
# Docs at https://github.com/metricfu/metric_fu/
#gem 'metric_fu', group: :metrics, require: false

group :production do
  gem 'unicorn'
  gem 'pg'
  gem 'execjs'
end

# Assets
gem 'therubyracer', '~> 0.12.2'
gem 'less-rails', '~> 2.7', '>= 2.7.1'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'coffee-rails', '~> 4.1.1'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 2.4', '>= 2.4.1'

## UI
gem 'font-awesome-rails', '~> 4.5.0.1'
gem 'will_paginate', '~> 3.1.0'
gem 'bootstrap-will_paginate', '~> 0.0.10'
gem 'simple_form', '~> 3.2.1'
gem 'data-confirm-modal', github: 'ifad/data-confirm-modal'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
