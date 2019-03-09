# frozen_string_literal: true

class AddTimestampsToVagrantConfig < ActiveRecord::Migration[5.2]
  def change
    add_column :vagrant_configs, :created_at, :datetime
    add_column :vagrant_configs, :updated_at, :datetime
  end
end
