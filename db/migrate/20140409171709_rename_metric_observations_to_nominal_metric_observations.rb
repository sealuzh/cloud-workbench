# frozen_string_literal: true

class RenameMetricObservationsToNominalMetricObservations < ActiveRecord::Migration[5.0]
  def change
    rename_table :metric_observations, :nominal_metric_observations
  end
end
