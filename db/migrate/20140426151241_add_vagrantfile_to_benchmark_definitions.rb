class AddVagrantfileToBenchmarkDefinitions < ActiveRecord::Migration
  def change
    add_column :benchmark_definitions, :vagrantfile, :text
  end
end
