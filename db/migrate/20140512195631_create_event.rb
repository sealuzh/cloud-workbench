class CreateEvent < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :name
      t.datetime :happened_at
      t.references :traceable, polymorphic: true

      t.timestamps
    end
  end
end
