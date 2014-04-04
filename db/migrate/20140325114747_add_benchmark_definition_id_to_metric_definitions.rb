class AddBenchmarkDefinitionIdToMetricDefinitions < ActiveRecord::Migration
  def change
    add_column :metric_definitions, :benchmark_definition_id, :integer
  end
end
