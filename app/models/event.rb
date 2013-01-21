class Event < ActiveRecord::Base
  attr_accessible :category, :custom_address, :date_and_time, :descreption, :location_type, :title, :tournament_id

  has_one :offering_creation, as: :offering
  accepts_nested_attributes_for :offering_creation


	def creator
		User.find_by_id(self.offering_creation.creator_id) unless self.offering_creation.nil?
	end
end
