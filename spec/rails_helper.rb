require 'rubygems'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# Support for deprecated `its` in RSpec 3 discussed in: https://gist.github.com/myronmarston/4503509
require 'rspec/its'

# Recursively require supporting files (e.g., custom matchers)
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/features/support/**/*.rb")].each { |f| require f }

# Run pending migrations automatically if any
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::DSL
  config.include AuthenticationHelpers, type: :feature

  # Must be false for Selenium support
  config.use_transactional_fixtures = false

  # Authentication helper
  config.after(:each) do
    Warden.test_reset!
  end

  # Database cleaner
  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # Transaction cannot be used with JS tests running in a separate thread
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # FactoryGirl
  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean_with(:deletion)
    end
  end

  # Clean file system
  config.after(:all) do
    if Rails.env.test? || Rails.env.cucumber?
      FileUtils.rm_rf Dir[Rails.application.config.storage]
    end
  end
end
