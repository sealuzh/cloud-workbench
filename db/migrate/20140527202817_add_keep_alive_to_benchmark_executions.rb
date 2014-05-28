class AddKeepAliveToBenchmarkExecutions < ActiveRecord::Migration
  def change
    add_column :benchmark_executions, :keep_alive, :boolean, default: false
  end
end
