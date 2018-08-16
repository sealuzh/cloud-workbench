class CreateVirtualMachineDefinitions < ActiveRecord::Migration[5.0]
  def change
    create_table :virtual_machine_definitions do |t|
      t.string :role
      t.string :region
      t.string :instance_type
      t.string :image

      t.timestamps
    end
  end
end
