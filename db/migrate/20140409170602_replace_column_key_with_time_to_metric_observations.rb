class ReplaceColumnKeyWithTimeToMetricObservations < ActiveRecord::Migration
  def change
    remove_column :metric_observations, :key
    add_column :metric_observations, :time, :integer, limit: 8
  end
end
