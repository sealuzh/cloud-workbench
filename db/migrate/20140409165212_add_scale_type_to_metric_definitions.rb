# frozen_string_literal: true

class AddScaleTypeToMetricDefinitions < ActiveRecord::Migration[5.0]
  def change
    add_column :metric_definitions, :scale_type, :string
  end
end
