# frozen_string_literal: true

class AddBenchmarkExecutionRefToVirtualMachineInstance < ActiveRecord::Migration[5.0]
  def change
    add_reference :virtual_machine_instances, :benchmark_execution, index: true
  end
end
