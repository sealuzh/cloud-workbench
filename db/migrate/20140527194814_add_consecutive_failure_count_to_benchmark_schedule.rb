class AddConsecutiveFailureCountToBenchmarkSchedule < ActiveRecord::Migration
  def change
    add_column :benchmark_schedules, :consecutive_failure_count, :integer, default: 0
  end
end
