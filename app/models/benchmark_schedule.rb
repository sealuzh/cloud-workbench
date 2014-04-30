require 'pathname'
require 'fileutils'
require 'erb'
class BenchmarkSchedule < ActiveRecord::Base
  belongs_to :benchmark_definition
  validates :benchmark_definition, presence: true
  # Very loose matching. Does no complete validation. Matches:
  # 1) MUST contain 4 whitespaces (separating the 5 columns which may contain arbitrary characters)
  # 2) MUST NOT start with '*' to avoid the mistake that a benchmark is run every minute!
  VALID_CRONTAB_REGEX = /[^\*].*\s.+\s.+\s.+\s.+/
  # TODO: enable after testing
  # validates :crontab, format: { with: VALID_CRONTAB_REGEX }
  after_update :check_and_update_system_crontab

  def crontab_in_english
    Cron2English.parse(self.crontab).join(' ')
  end

  def self.actives
    BenchmarkSchedule.where("active = ?", true)
  end

  def self.update_system_crontab
    # TODO: Fetch from app config (=> string is safer than Pathname)
    template_path = "#{Rails.root}/lib/templates/erb/whenever_schedule.rb.erb"
    schedule_path = "#{Rails.root}/storage/development/benchmark_schedules/whenever_schedule.rb"

    schedule = generate_schedule_from_template(template_path)
    write_content_to_file(schedule, schedule_path)
    apply_schedule_to_cron(schedule_path)
  end

  def self.generate_schedule_from_template(template_path)
    # actives = self.actives
    template = ERB.new File.read(template_path)
    template.result(binding)
  end

  def self.write_content_to_file(schedule, schedule_path)
    parent_dir = Pathname.new(schedule_path).parent
    FileUtils::mkdir_p(parent_dir)
    File.open(schedule_path, 'w') do |f|
      f.write(schedule)
    end
  end

  def self.apply_schedule_to_cron(schedule_path)
    %x(whenever --update-crontab -f "#{schedule_path}")
  end

  private

    def check_and_update_system_crontab
      if active_changed? || active && crontab_changed?
        BenchmarkSchedule.update_system_crontab
      end
    end

end
