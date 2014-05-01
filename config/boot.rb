# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

# Use nodejs javascript runtime in production
ENV['EXECJS_RUNTIME'] = 'Node' if Rails.env == 'production'