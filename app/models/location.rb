class Location < ActiveRecord::Base
  attr_accessible :city, :custom_address, :custom_address_use, :gmap_use, :latitude, :longitude, :owner_id, :owner_type, :title, :gmaps

  belongs_to :owner, polymorphic: true
  acts_as_gmappable

  def gmaps4rails_address
    self.custom_address.to_s
  end

end
