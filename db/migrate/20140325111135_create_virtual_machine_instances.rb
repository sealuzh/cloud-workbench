# frozen_string_literal: true

class CreateVirtualMachineInstances < ActiveRecord::Migration[5.0]
  def change
    create_table :virtual_machine_instances do |t|
      t.string :status

      t.timestamps
    end
  end
end
