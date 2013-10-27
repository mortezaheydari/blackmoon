class Location < ActiveRecord::Base
  attr_accessible :city, :custom_address, :custom_address_use, :gmap_use, :latitude, :longitude, :owner_id, :owner_type, :title

  belongs_to :owner, polymorphic: true

  def gmaps4rails_address
    custom_address
  end

  def gmaps4rails_infowindow
    "<h1>#{title}</h1>"
  end

end
