class CreateBenchmarkSchedules < ActiveRecord::Migration
  def change
    create_table :benchmark_schedules do |t|
      t.string :crontab
      t.boolean :active, default: true
      t.references :benchmark_definition, index: true

      t.timestamps
    end
  end
end
