source 'https://rubygems.org'
ruby '2.1.1'
#ruby-gemset=cloud_benchmarking

gem 'rails', '4.1.1'

# NOTE: This gem is not thread-safe and SHOULD NOT be used with
#       threaded web servers such as puma.
gem 'silencer', '~> 0.6.0'
gem 'whenever', '~> 0.9.2'
gem 'cron2english', '~> 0.1.3'
gem 'delayed_job_active_record', '~> 4.0.0'
gem 'enumerize', '~> 0.8.0'

group :development do
  gem 'pry'
  gem 'pry-rails' # Use pry as Rails console
  gem 'launchy'
  gem 'guard-livereload', '~> 2.1.2', require: false
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'

  # Deploy with Capistrano
  gem 'capistrano', '~> 3.2.1', require: false
  gem 'capistrano-rails', '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1.2', require: false
  gem 'capistrano-rbenv', '~> 2.0', require: false
  # gem 'rvm1-capistrano3', require: false # Use if deploying into RVM environments
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', '~> 2.14.2'
  gem 'fuubar'
  gem 'guard-rspec', '~> 4.2.8'

  gem 'spork-rails', '~> 4.0.0'
  gem 'guard-spork', '~> 1.5.1'
  gem 'childprocess', '~> 0.5.3'
end

group :test do
  gem 'capybara', '~> 2.2.1'
  gem 'selenium-webdriver', '~> 2.41.0'
  gem 'database_cleaner', '~> 1.2.0'
  gem 'factory_girl_rails', '~> 4.4.1'

  ## For Guard notifications:
  # Uncomment this line on OS X.
  # gem 'growl', '~> 1.0.3'

  # Uncomment these lines on Linux.
  # gem 'libnotify', '~> 0.8.2'

  # Uncomment these lines on Windows.
  # gem 'rb-notifu', '0.0.4'
  # gem 'wdm', '0.1.0'
end

group :production do
  gem 'unicorn'
  gem 'pg'
  gem 'execjs'
end

# Assets
gem 'therubyracer', '~> 0.12.1'
gem 'less-rails', '~> 2.5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'coffee-rails', '~> 4.0.0'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'

## Bootstrap and UI
# Fix for Rails 4.1 flash message helper not released yet (2014-05-14) in version 2.2.8
# See https://github.com/seyhunak/twitter-bootstrap-rails/issues/721
# gem 'twitter-bootstrap-rails', github: 'seyhunak/twitter-bootstrap-rails'
gem 'font-awesome-rails', '~> 4.0.3.1'
gem 'will_paginate', '~> 3.0.5'
gem 'bootstrap-will_paginate', '~> 0.0.10'
gem 'simple_form', '~> 3.0.2'


group :chef do
  # Chef: Use the Chef gem since the omnibus installer with Chef-client version <=11.12.2
  # is not yet compatible (planned for 11.14.0) with ruby version managers such as RVM or rbenv.
  # See issue: https://tickets.opscode.com/browse/CHEF-3581
  gem 'chef', '~> 11.12.2', require: false
  gem 'berkshelf', '~> 3.1.1', require: false
  gem 'foodcritic', '~> 3.0.3', require: false
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use debugger
# gem 'debugger', group: [:development, :test]
