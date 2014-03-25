class CreateVirtualMachineInstances < ActiveRecord::Migration
  def change
    create_table :virtual_machine_instances do |t|
      t.string :status

      t.timestamps
    end
  end
end
