# frozen_string_literal: true

class CreateMetricDefinitions < ActiveRecord::Migration[5.0]
  def change
    create_table :metric_definitions do |t|
      t.string :name
      t.string :unit

      t.timestamps
    end
  end
end
