class Event < ActiveRecord::Base

	include PublicActivity::Model
  # tracked except: :destroy, owner: ->(controller, model) {controller && controller.current_user}

  attr_accessible :category, :custom_address, :date_and_time, :descreption,
  				 :location_type, :title, :tournament_id, :duration_type, :time_from,
  				 :time_to, :fee, :fee_type, :sport, :number_of_attendings, :team_participation
  before_save :default_values

	after_create do |event|
		event.create_album if event.album.nil?
		event.create_logo if event.logo.nil?
	end

	make_flaggable :like

  has_one :album, as: :owner, :dependent => :destroy
  accepts_nested_attributes_for :album

  has_one :logo, as: :owner, :dependent => :destroy
  accepts_nested_attributes_for :logo

  has_one :offering_creation, as: :offering, :dependent => :destroy
  accepts_nested_attributes_for :offering_creation

  has_many :offering_administrations, as: :offering, :dependent => :destroy
  accepts_nested_attributes_for :offering_administrations

  has_many :offering_individual_participations, as: :offering, :dependent => :destroy
  accepts_nested_attributes_for :offering_individual_participations

  has_many :offering_team_participations, as: :offering, :dependent => :destroy
  accepts_nested_attributes_for :offering_team_participations

	has_one :happening_case, as: :happening, :dependent => :destroy
	accepts_nested_attributes_for :happening_case  

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
