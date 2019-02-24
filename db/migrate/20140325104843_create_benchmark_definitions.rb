# frozen_string_literal: true

class CreateBenchmarkDefinitions < ActiveRecord::Migration[5.0]
  def change
    create_table :benchmark_definitions do |t|
      t.string :name

      t.timestamps
    end
  end
end
