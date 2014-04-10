class AddVirtualMachineDefinitionRefToVirtualMachineInstance < ActiveRecord::Migration
  def change
    add_reference :virtual_machine_instances, :virtual_machine_definition, index: { name: 'index_vm_instances_on_vm_definition_id' }
  end
end
