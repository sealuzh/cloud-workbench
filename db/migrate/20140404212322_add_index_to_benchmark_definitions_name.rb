# frozen_string_literal: true

class AddIndexToBenchmarkDefinitionsName < ActiveRecord::Migration[5.0]
  def change
    add_index :benchmark_definitions, :name, unique: true
  end
end
