# frozen_string_literal: true

class RemoveStatusFromVirtualMachineInstances < ActiveRecord::Migration[5.0]
  def change
    remove_column :virtual_machine_instances, :status
  end
end
