# frozen_string_literal: true

class CreateBenchmarkSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :benchmark_schedules do |t|
      t.string :cron_expression
      t.boolean :active, default: true
      t.references :benchmark_definition, index: true

      t.timestamps
    end
  end
end
