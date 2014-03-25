class CreateBenchmarkExecutions < ActiveRecord::Migration
  def change
    create_table :benchmark_executions do |t|
      t.string :status
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
