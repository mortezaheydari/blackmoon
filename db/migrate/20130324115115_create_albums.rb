class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.integer :owner_id
      t.string :owner_type

      t.timestamps
    end
  end
end
