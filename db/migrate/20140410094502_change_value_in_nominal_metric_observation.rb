class ChangeValueInNominalMetricObservation < ActiveRecord::Migration
  def change
    change_column :nominal_metric_observations, :value, :float
  end
end
