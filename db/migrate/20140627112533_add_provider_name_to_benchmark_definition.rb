# frozen_string_literal: true

class AddProviderNameToBenchmarkDefinition < ActiveRecord::Migration[5.0]
  def change
    add_column :benchmark_definitions, :provider_name, :string
  end
end
