# frozen_string_literal: true

class AddCloudProviderRefToVirtualMachineDefinition < ActiveRecord::Migration[5.0]
  def change
    add_reference :virtual_machine_definitions, :cloud_provider, index: true
  end
end
