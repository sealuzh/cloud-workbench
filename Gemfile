source 'https://rubygems.org'
ruby '2.1.1'
#ruby-gemset=cloud_benchmarking

gem 'rails', '4.0.4'

gem 'delayed_job_active_record', '~> 4.0.0'
gem 'enumerize', '~> 0.8.0'

# Consider using separate groups for cookbook authoring and deployment
group :development do
  # Chef: Use the Chef gem since the omnibus installer with Chef-client version <=11.12.2
  # is not yet compatible (planned for 11.14.0) with ruby version managers such as RVM or rbenv.
  # See issue: https://tickets.opscode.com/browse/CHEF-3581
  gem 'chef', '~> 11.12.2', require: false
  gem 'berkshelf', '~> 3.0.1', require: false
  gem 'foodcritic', '~> 3.0.3', require: false

  # Deploy with Capistrano
  gem 'capistrano', '~> 3.2.0', require: false
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1.2', require: false
  gem 'capistrano-rbenv', '~> 2.0', require: false
  # gem 'rvm1-capistrano3', require: false # Use if deploying into RVM environments
end

group :development, :test do
  gem 'sqlite3'
end

gem 'sass-rails', '~> 4.0.2'
gem 'therubyracer', '~> 0.12.1'
gem 'less-rails', '~> 2.5.0'
gem 'twitter-bootstrap-rails', '~> 2.2.8'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'

group :production do
  gem 'unicorn'
  gem 'pg'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use debugger
# gem 'debugger', group: [:development, :test]
