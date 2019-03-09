# frozen_string_literal: true

class AddRoleToVirtualMachineInstance < ActiveRecord::Migration[5.0]
  def change
    add_column :virtual_machine_instances, :role, :string
  end
end
