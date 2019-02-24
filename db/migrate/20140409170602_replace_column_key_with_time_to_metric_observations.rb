# frozen_string_literal: true

class ReplaceColumnKeyWithTimeToMetricObservations < ActiveRecord::Migration[5.0]
  def change
    remove_column :metric_observations, :key
    add_column :metric_observations, :time, :integer, limit: 8
  end
end
