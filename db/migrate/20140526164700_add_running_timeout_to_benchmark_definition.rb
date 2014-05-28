class AddRunningTimeoutToBenchmarkDefinition < ActiveRecord::Migration
  def change
    add_column :benchmark_definitions, :running_timeout, :integer
  end
end
