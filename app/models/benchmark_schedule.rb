require 'pathname'
require 'fileutils'
require 'erb'
class BenchmarkSchedule < ActiveRecord::Base
  belongs_to :benchmark_definition
  validates :benchmark_definition, presence: true
  after_update :check_and_update_system_crontab

  def crontab_in_english
    Cron2English.parse(self.crontab).join(' ')
  end

  def self.actives
    BenchmarkSchedule.where("active = ?", true)
  end

  def self.update_system_crontab
    self.generate_from_template
    self.apply_to_cron
  end

  def self.generate_from_template
    # Config
    erb_template_path = Pathname.new "#{Rails.root}/lib/templates/erb/whenever_schedule.rb.erb"
    result_path       = Pathname.new "#{Rails.root}/storage/development/benchmark_schedules/whenever_schedule.rb"

    # crontab = "1 2 3 4 5"
    actives = self.actives
    template = ERB.new File.read(erb_template_path)
    result = template.result(binding)

    FileUtils::mkdir_p(result_path.parent)
    File.open(result_path, 'w') do |f|
      f.write(result)
    end

  end

  def self.apply_to_cron
    # %x(whenever --update-crontab #{result_path})
  end

  private

    def check_and_update_system_crontab
      # self.update_system_crontab if self.active_changed?
    end

end
