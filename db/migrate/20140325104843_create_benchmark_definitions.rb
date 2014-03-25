class CreateBenchmarkDefinitions < ActiveRecord::Migration
  def change
    create_table :benchmark_definitions do |t|
      t.string :name

      t.timestamps
    end
  end
end
