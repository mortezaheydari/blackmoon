class Album < ActiveRecord::Base
  attr_accessible :owner_id, :owner_type, :title

  has_many :album_photos, :dependent => :destroy
  accepts_nested_attributes_for :album_photos
	belongs_to :owner, polymorphic: true

end
