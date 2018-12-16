class ChangeBaseFileOfVagrantConfig < ActiveRecord::Migration[5.2]
  def change
    change_column :vagrant_configs, :base_file, :text
  end
end
