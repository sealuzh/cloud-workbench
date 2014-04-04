class AddMetricDefinitionRefToMetricObservation < ActiveRecord::Migration
  def change
    add_reference :metric_observations, :metric_definition, index: true
  end
end
