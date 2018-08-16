class CreateMetricObservations < ActiveRecord::Migration[5.0]
  def change
    create_table :metric_observations do |t|
      t.integer :key
      t.string :value

      t.timestamps
    end
  end
end
