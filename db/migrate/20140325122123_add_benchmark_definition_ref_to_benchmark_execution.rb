class AddBenchmarkDefinitionRefToBenchmarkExecution < ActiveRecord::Migration
  def change
    add_reference :benchmark_executions, :benchmark_definition, index: true
  end
end
