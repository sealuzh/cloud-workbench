class AddRoleToVirtualMachineInstance < ActiveRecord::Migration
  def change
    add_column :virtual_machine_instances, :role, :string
  end
end
