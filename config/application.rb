require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CloudBenchmarking
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework  :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W(
      #{Rails.root}/app/jobs
    )

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'CET' # CET := Central European Time

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    ### CloudBenchmarking settings
    # VMs
    config.vm_benchmark_dir = '/usr/local/cloud-benchmark'
    config.vm_start_runner = 'start_runner.sh'
    config.vm_start_postprocessing = 'stop_and_postprocess_runner.sh'

    # String of supported providers that Vagrant uses as directory name (should be the same as used with vagrant up)
    config.supported_providers = %w(aws)

    # Main paths
    config.storage = File.join(Rails.root, 'storage', Rails.env)
    config.log = File.join(Rails.root, 'log')
    config.templates = File.join(Rails.root, 'lib', 'templates')

    # Benchmark definition
    config.vagrantfile_template = File.join(config.templates, 'erb', 'Vagrantfile.erb')

    # Benchmark execution
    config.benchmark_executions = File.join(config.storage, 'benchmark_executions')

    # Benchmark schedule
    config.benchmark_schedule_template = File.join(config.templates, 'erb', 'whenever_schedule.rb.erb')
    config.benchmark_schedule = File.join(config.storage, 'benchmark_schedules', 'whenever_schedule.rb')
    config.benchmark_schedule_log = File.join(config.log, 'benchmark_schedule.log')
  end
end
