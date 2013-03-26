class Game < ActiveRecord::Base
  attr_accessible :category, :custom_address, :date_and_time, :description, :duration_type,
  	:fee, :fee_type, :location_type, :number_of_attendings, :sport,
  	:team_participation, :time_from, :time_to, :title, :tournament_id

  before_save :default_values

  has_one :album, as: :owner, :dependent => :destroy
  has_one :logo, as: :owner, :dependent => :destroy

	make_flaggable :like

  has_one :offering_creation, as: :offering, :dependent => :destroy
  accepts_nested_attributes_for :offering_creation

  has_many :offering_administrations, as: :offering, :dependent => :destroy
  accepts_nested_attributes_for :offering_administrations

  has_many :offering_individual_participations, as: :offering, :dependent => :destroy
  accepts_nested_attributes_for :offering_individual_participations

  has_many :offering_team_participations, as: :offering, :dependent => :destroy
  accepts_nested_attributes_for :offering_team_participations

	has_many :invitations, as: :subject, dependent: :destroy
	accepts_nested_attributes_for :invitations
	
	def creator
		User.find_by_id(self.offering_creation.creator_id) unless self.offering_creation.nil?
	end

	def administrators
		@admins = []
		self.offering_administrations.each do |admin|
			@admins << admin.administrator_id
		end
		User.find(@admins)
	end

	def individual_participators
		@participators = []
		self.offering_individual_participations.each do |participation|
			@participators << participation.participator_id
		end
		User.find(@participators)
	end

	def team_participators
		@participators = []
		self.offering_team_participations.each do |participation|
			@participators << participation.participator_id
		end
		Team.find(@participators)
	end

  def default_values
    self.number_of_attendings ||= 0
  end
end
