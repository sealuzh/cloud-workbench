class AddIndexOnNameToMetricDefinitions < ActiveRecord::Migration[5.0]
  def change
    # Ensure scoped uniqueness constraint of metrics_definitions:
    # The name of a metric definition MUST be unique within the scope of a benchmark definition
    add_index :metric_definitions, [:name, :benchmark_definition_id], unique: true
  end
end
