class AddMessageToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :message, :text
  end
end
