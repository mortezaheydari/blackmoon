class Location < ActiveRecord::Base
	attr_accessible :city, :custom_address, :custom_address_use, :gmap_use, :latitude, :longitude, :owner_id, :owner_type, :title, :gmaps, :parent_id
	attr_accessor :parent, :parent_location, :parent_venue

	belongs_to :owner, polymorphic: true

	belongs_to :parent, class_name: "Location"; accepts_nested_attributes_for :parent
	has_many :child_locations, as: :parent, class_name: "Location"; accepts_nested_attributes_for :child_locations
	before_destroy :detach_childs

	acts_as_gmappable

	def gmaps4rails_address
		self.custom_address.to_s
	end

	def parent_location
		if !parent_id.nil?
			location = Location.find(parent_id)
		else
			nil
		end
	end

	def parent_venue
		if !parent_id.nil?
			location = Location.find(parent_id)
			location.owner
		else
			nil
		end
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
