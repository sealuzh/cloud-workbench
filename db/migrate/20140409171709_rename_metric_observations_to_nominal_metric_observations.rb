class RenameMetricObservationsToNominalMetricObservations < ActiveRecord::Migration
  def change
    rename_table :metric_observations, :nominal_metric_observations
  end
end
