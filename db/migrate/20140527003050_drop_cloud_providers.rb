class DropCloudProviders < ActiveRecord::Migration
  def change
    drop_table :cloud_providers
  end
end
