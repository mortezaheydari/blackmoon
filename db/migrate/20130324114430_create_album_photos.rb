class CreateAlbumPhotos < ActiveRecord::Migration
  def change
    create_table :album_photos do |t|
      t.integer :album_id
      t.integer :photo_id

      t.timestamps
    end
  end
end
