class AddBenchmarkExecutionRefToMetricObservation < ActiveRecord::Migration
  def change
    add_reference :metric_observations, :benchmark_execution, index: true
  end
end
