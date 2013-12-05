class Photo < ActiveRecord::Base
  attr_accessible :title, :image

            has_attached_file :image, :styles => { :medium => "200x200>", :thumb => "100x100>", :large => "1024x768>", :small => "50x50#", :user_profile => "156x156#", :offering_card => "200x160#" }

	validates_attachment :image,
		:presence => true,
		:content_type => { :content_type =>  ['image/png', 'image/jpg', 'image/jpeg'] },
		:size => { :in => 0..10000.kilobytes }


	has_many :logos
	accepts_nested_attributes_for :logos
	has_many :album_photos, :dependent => :destroy
	accepts_nested_attributes_for :album_photos

	def uses
		@uses = []
		logos.each do |logo|
			@uses << logo
		end
		album_photos.each do |album_photo|
			@uses << album_photo
		end
	end

end