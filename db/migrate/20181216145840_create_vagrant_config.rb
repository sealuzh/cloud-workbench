class CreateVagrantConfig < ActiveRecord::Migration[5.2]
  def change
    create_table :vagrant_configs do |t|
      t.integer  :singleton_guard

      t.string :base_file
    end
    add_index(:vagrant_configs, :singleton_guard, unique: true)
  end
end
