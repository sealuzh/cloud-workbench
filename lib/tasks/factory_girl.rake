# frozen_string_literal: true

# Linting factories: https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#linting-factories
namespace :factory_bot do
  desc 'Verify that all FactoryBot factories are valid'
  task lint: :environment do
    if Rails.env.test?
      begin
        DatabaseCleaner.start
        FactoryBot.lint
      ensure
        DatabaseCleaner.clean
      end
    else
      system("bin/rake factory_bot:lint RAILS_ENV='test'")
    end
  end
end
