class AddBenchmarkDefinitionRefToVirtualMachineDefinition < ActiveRecord::Migration
  def change
    add_reference :virtual_machine_definitions, :benchmark_definition, index: true
  end
end
