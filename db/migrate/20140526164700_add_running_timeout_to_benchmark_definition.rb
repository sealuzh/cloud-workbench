# frozen_string_literal: true

class AddRunningTimeoutToBenchmarkDefinition < ActiveRecord::Migration[5.0]
  def change
    add_column :benchmark_definitions, :running_timeout, :integer
  end
end
