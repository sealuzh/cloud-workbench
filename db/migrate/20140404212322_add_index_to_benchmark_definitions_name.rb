class AddIndexToBenchmarkDefinitionsName < ActiveRecord::Migration
  def change
    add_index :benchmark_definitions, :name, unique: true
  end
end
