class AddKeepAliveToBenchmarkExecutions < ActiveRecord::Migration[5.0]
  def change
    add_column :benchmark_executions, :keep_alive, :boolean, default: false
  end
end
