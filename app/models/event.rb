class Event < ActiveRecord::Base
  attr_accessible :category, :custom_address, :date_and_time, :descreption, :location_type, :title, :tournament_id

  has_one :offering_creation, as: :offering
	has_many :creator, :through => :offering_creation, :source => :creator_id
end
