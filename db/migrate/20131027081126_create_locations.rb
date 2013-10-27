class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :title
      t.string :city
      t.text :custom_address
      t.boolean :custom_address_use,          :default => true
      t.float :latitude
      t.float :longitude
      t.boolean :gmap_use,          :default => true
      t.string :owner_type
      t.integer :owner_id

      t.timestamps
    end
  end
end
