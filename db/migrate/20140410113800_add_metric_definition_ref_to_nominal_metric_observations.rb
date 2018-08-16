class AddMetricDefinitionRefToNominalMetricObservations < ActiveRecord::Migration[5.0]
  def change
    add_reference :nominal_metric_observations, :metric_definition, index: true
  end
end
