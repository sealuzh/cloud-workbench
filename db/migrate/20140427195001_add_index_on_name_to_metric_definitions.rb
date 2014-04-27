class AddIndexOnNameToMetricDefinitions < ActiveRecord::Migration
  def change
    add_index :metric_definitions, :name, unique: true
  end
end
