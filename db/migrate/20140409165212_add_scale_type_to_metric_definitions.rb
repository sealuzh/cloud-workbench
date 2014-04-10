class AddScaleTypeToMetricDefinitions < ActiveRecord::Migration
  def change
    add_column :metric_definitions, :scale_type, :string
  end
end
