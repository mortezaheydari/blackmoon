class AddGmappsToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :gmaps, :boolean,          :default => true
  end
end
