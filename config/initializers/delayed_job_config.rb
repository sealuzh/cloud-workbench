# frozen_string_literal: true

# config/initializers/delayed_job_config.rb
# see https://github.com/collectiveidea/delayed_job
Delayed::Worker.backend = :active_record
Delayed::Worker.destroy_failed_jobs = true
Delayed::Worker.sleep_delay = 5
Delayed::Worker.max_attempts = 1
Delayed::Worker.max_run_time = 4.hours
Delayed::Worker.read_ahead = 2
Delayed::Worker.default_queue_name = 'default'
# This would immediately run the job in tests!
# May be useful for some tests but as long as
# Delayed::Worker.delay_jobs = !Rails.env.test?