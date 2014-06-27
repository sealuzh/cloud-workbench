class AddProviderNameToBenchmarkDefinition < ActiveRecord::Migration
  def change
    add_column :benchmark_definitions, :provider_name, :string
  end
end
