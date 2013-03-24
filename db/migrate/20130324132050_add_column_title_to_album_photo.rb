class AddColumnTitleToAlbumPhoto < ActiveRecord::Migration
  def change
    add_column :album_photos, :title, :string  	
  end
end
