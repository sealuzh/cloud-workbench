# frozen_string_literal: true

class AddBenchmarkDefinitionIdToMetricDefinitions < ActiveRecord::Migration[5.0]
  def change
    add_column :metric_definitions, :benchmark_definition_id, :integer
  end
end
