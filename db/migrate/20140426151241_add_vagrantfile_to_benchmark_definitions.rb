class AddVagrantfileToBenchmarkDefinitions < ActiveRecord::Migration[5.0]
  def change
    add_column :benchmark_definitions, :vagrantfile, :text
  end
end
