class Photo < ActiveRecord::Base
  attr_accessible :title, :image

	validates_attachment :image, 
		:presence => true, 
		:content_type => { :content_type =>  ['image/png', 'image/jpg', 'image/jpeg'] },  
		:size => { :in => 0..10000.kilobytes }  

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }

	has_many :logos
	accepts_nested_attributes_for :logos
	has_many :album_photos
	accepts_nested_attributes_for :album_photos

end