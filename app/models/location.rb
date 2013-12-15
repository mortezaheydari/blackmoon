class Location < ActiveRecord::Base
	attr_accessible :city, :custom_address, :custom_address_use, :gmap_use, :latitude, :longitude, :owner_id, :owner_type, :title, :gmaps, :parent_id

	belongs_to :owner, polymorphic: true

	belongs_to :parent; accepts_nested_attributes_for :parent
	has_many :child_locations, as: :parent; accepts_nested_attributes_for :child_locations
	before_destroy :detach_childs

	acts_as_gmappable

	def gmaps4rails_address
		self.custom_address.to_s
	end

	private
		def detach_childs
			childs = self.child_locations
			childs.each do |child|
				child.custom_address = custom_address
				child.custom_address_use = custom_address_use  		
				child.gmap_use = gmap_use
				child.gmaps = gmaps
				child.latitude = latitude  	  		
				child.longitude = longitude  	  		  		
				child.title = title
				child.parent_id = nil
				child.save
			end
		end

end
