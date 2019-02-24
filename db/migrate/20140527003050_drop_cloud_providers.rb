# frozen_string_literal: true

class DropCloudProviders < ActiveRecord::Migration[5.0]
  def change
    drop_table :cloud_providers
  end
end
