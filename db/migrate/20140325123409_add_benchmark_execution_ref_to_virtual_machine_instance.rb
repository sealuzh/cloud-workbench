class AddBenchmarkExecutionRefToVirtualMachineInstance < ActiveRecord::Migration
  def change
    add_reference :virtual_machine_instances, :benchmark_execution, index: true
  end
end
