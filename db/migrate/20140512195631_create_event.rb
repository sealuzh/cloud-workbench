# frozen_string_literal: true

class CreateEvent < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.integer :name
      t.datetime :happened_at
      t.references :traceable, polymorphic: true

      t.timestamps
    end
  end
end
