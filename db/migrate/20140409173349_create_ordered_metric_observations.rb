class CreateOrderedMetricObservations < ActiveRecord::Migration
  def change
    create_table :ordered_metric_observations do |t|
      t.references :metric_definition, index: true
      t.references :virtual_machine_instance, index: { name: 'index_ordered_metric_observations_on_vm_instance_id' }
      t.integer :time, limit: 8
      t.float :value

      t.timestamps
    end
  end
end
