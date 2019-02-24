# frozen_string_literal: true

class AddBenchmarkDefinitionRefToVirtualMachineDefinition < ActiveRecord::Migration[5.0]
  def change
    add_reference :virtual_machine_definitions, :benchmark_definition, index: true
  end
end
