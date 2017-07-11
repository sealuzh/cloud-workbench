class DropVirtualMachineDefinitions < ActiveRecord::Migration[5.0]
  def change
    drop_table :virtual_machine_definitions
    remove_column :virtual_machine_instances, :virtual_machine_definition_id
  end
end
