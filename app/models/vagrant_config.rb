# frozen_string_literal: true

class VagrantConfig < ActiveRecord::Base
  # Single implementation based on: https://stackoverflow.com/a/12463209/6875981
  # The "singleton_guard" column is a unique column which must always be set to '0'
  # This ensures that only one VagrantConfig row is created
  validates_inclusion_of :singleton_guard, in: [0]

  def self.instance
    first_or_create!(singleton_guard: 0) do |vagrant_config|
      vagrant_config.base_file = self.default_base_file
    end
  end

  # Resets the base file to the latest default provided in the codebase
  def self.reset_defaults!
    self.instance.update!(base_file: self.default_base_file)
  end

  private

    def self.default_base_file
      File.read(Rails.application.config.vagrantfile)
    end
end
