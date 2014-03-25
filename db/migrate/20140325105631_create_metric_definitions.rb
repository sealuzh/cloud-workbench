class CreateMetricDefinitions < ActiveRecord::Migration
  def change
    create_table :metric_definitions do |t|
      t.string :name
      t.string :unit

      t.timestamps
    end
  end
end
