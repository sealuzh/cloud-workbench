class AddCloudProviderRefToVirtualMachineDefinition < ActiveRecord::Migration
  def change
    add_reference :virtual_machine_definitions, :cloud_provider, index: true
  end
end
