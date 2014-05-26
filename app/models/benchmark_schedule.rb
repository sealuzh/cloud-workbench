require 'pathname'
require 'fileutils'
require 'erb'
class BenchmarkSchedule < ActiveRecord::Base
  scope :actives, -> { where(active: true) }
  DEFAULT_TEMPLATE_PATH = Rails.application.config.benchmark_schedule_template
  DEFAULT_SCHEDULE_PATH = Rails.application.config.benchmark_schedule
  belongs_to :benchmark_definition
  validates :benchmark_definition, presence: true
  # Very loose matching. Does no complete validation. Matches:
  # 1) MUST contain 4 whitespaces (separating the 5 columns which may contain arbitrary characters)
  # 2) MUST NOT start with '*' to avoid the mistake that a benchmark is run every minute!
  VALID_CRON_EXPRESSION_REGEX = /[^\*].*\s.+\s.+\s.+\s.+/
  validates :cron_expression, presence: true,
                              format: { with: VALID_CRON_EXPRESSION_REGEX,
                                        message: "Cron expression MUST NOT start with '*' and
                                                  MUST contain 4 whitespaces separating the 5 columns." }
  after_create   :update_system_crontab_if_active
  before_destroy { self.active = false; save }
  after_update :check_and_update_system_crontab_after_update

  def activate!
    self.active = true
    save!
  end

  def deactivate!
    self.active = false
    save!
  end

  # Gem that with 'best effort' translation attempt
  # The best known cron expression to english translator has been found here but this requires php installed:
  # http://www.joostbrugman.com/bitsofthought/page/4/Converting_Crontab_Entries_To_Plain_English_%28Or_Any_Other_Language%29
  def cron_expression_in_english
    Cron2English.parse(self.cron_expression).join(' ')
  rescue Cron2English::ParseException => e
    e.message
  end

  def self.update_system_crontab
    schedule = generate_schedule_from_template(DEFAULT_TEMPLATE_PATH)
    write_content_to_file(schedule, DEFAULT_SCHEDULE_PATH)
    apply_schedule_to_system_crontab(DEFAULT_SCHEDULE_PATH)
  end

  def self.generate_schedule_from_template(template_path = DEFAULT_TEMPLATE_PATH)
    template = ERB.new File.read(template_path)
    template.result(binding)
  end

  def self.apply_schedule_to_system_crontab(schedule_path = DEFAULT_SCHEDULE_PATH)
    result = %x(whenever --update-crontab -f "#{schedule_path}")
    unless $?.success?
      fail "Failed to update system crontab. #{result}"
    end
    $?.success?
  end

  def self.clear_system_crontab(schedule_path = DEFAULT_SCHEDULE_PATH)
    %x(whenever --clear-crontab -f "#{schedule_path}")
  end

  def self.filter(active_param)
    active = active_param.to_bool rescue nil
    active ? actives : all
  end

  private

    def update_system_crontab_if_active
      BenchmarkSchedule.update_system_crontab if active?
    end

    def check_and_update_system_crontab_after_update
      if active_changed? || active && cron_expression_changed?
        BenchmarkSchedule.update_system_crontab
      end
    end

    def self.write_content_to_file(schedule, schedule_path)
      parent_dir = Pathname.new(schedule_path).parent
      FileUtils::mkdir_p(parent_dir)
      File.open(schedule_path, 'w') do |f|
        f.write(schedule)
      end
    end

end
