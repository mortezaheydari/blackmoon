class Event < ActiveRecord::Base
  attr_accessible :category, :custom_address, :date_and_time, :descreption,
  				 :location_type, :title, :tournament_id, :duration_type, :time_from,
  				 :time_to, :fee, :fee_type, :sport, :number_of_attendings, :team_participation

  has_one :offering_creation, as: :offering, :dependent => :destroy
  accepts_nested_attributes_for :offering_creation

  has_many :offering_administrations, as: :offering, :dependent => :destroy
  accepts_nested_attributes_for :offering_administrations

	def creator
		User.find_by_id(self.offering_creation.creator_id) if !self.offering_creation.nil?
	end

	def administrators
		@admins = []
		self.offering_administrations.each do |admin|
			@admins << admin.administrator_id 
		end
		User.find(@admins)
	end	
end
