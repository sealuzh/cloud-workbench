class AddMetricDefinitionRefToNominalMetricObservations < ActiveRecord::Migration
  def change
    add_reference :nominal_metric_observations, :metric_definition, index: true
  end
end
