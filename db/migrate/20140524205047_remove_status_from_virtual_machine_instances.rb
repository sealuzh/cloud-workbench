class RemoveStatusFromVirtualMachineInstances < ActiveRecord::Migration
  def change
    remove_column :virtual_machine_instances, :status
  end
end
