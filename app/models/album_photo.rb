class AlbumPhoto < ActiveRecord::Base
  attr_accessible :album_id, :photo_id, :title

  belongs_to :photo
  accepts_nested_attributes_for :photo
  belongs_to :album
  accepts_nested_attributes_for :album
  
end
