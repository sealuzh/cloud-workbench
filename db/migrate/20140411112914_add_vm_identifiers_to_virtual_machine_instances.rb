class AddVmIdentifiersToVirtualMachineInstances < ActiveRecord::Migration[5.0]
  def change
    add_column :virtual_machine_instances, :provider_name, :string
    add_column :virtual_machine_instances, :provider_instance_id, :string

    add_index :virtual_machine_instances, [:provider_instance_id, :provider_name], name: 'index_vm_instances_on_provider_instance_id_and_provider_name'
  end
end
