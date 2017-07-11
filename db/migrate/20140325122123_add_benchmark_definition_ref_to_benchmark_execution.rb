class AddBenchmarkDefinitionRefToBenchmarkExecution < ActiveRecord::Migration[5.0]
  def change
    add_reference :benchmark_executions, :benchmark_definition, index: true
  end
end
