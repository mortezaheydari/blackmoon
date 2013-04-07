class Team < ActiveRecord::Base

  include PublicActivity::Model  
  attr_accessible :descreption, :name, :sport, :number_of_attendings, :title, :category
  before_save :default_values

  has_one :album, as: :owner, :dependent => :destroy
  has_one :logo, as: :owner, :dependent => :destroy

    after_create do |team|
        team.create_album if team.album.nil?
        team.create_logo if team.logo.nil?
    end

	make_flaggable :like

  has_one :album, as: :owner, :dependent => :destroy
  accepts_nested_attributes_for :album

  has_one :logo, as: :owner, :dependent => :destroy
  accepts_nested_attributes_for :logo

  has_one :act_creation, as: :act, :dependent => :destroy
  accepts_nested_attributes_for :act_creation

  has_many :act_administrations, as: :act, :dependent => :destroy
  accepts_nested_attributes_for :act_administrations

  has_many :act_memberships, as: :act, :dependent => :destroy
  accepts_nested_attributes_for :act_memberships

      # offering participation:
  has_many :offering_team_participations, foreign_key: :participator_id
      #   1.events participating
  has_many :events_participating, through: :offering_team_participations, source: :offering, source_type: "Event"
  accepts_nested_attributes_for :events_participating

      # invitations as invited and inviter
  has_many :invitations_sent, as: :inviter, class_name: "Invitation", dependent: :destroy
	accepts_nested_attributes_for :invitations_sent
  has_many :invitations_received, as: :invited, class_name: "Invitation", dependent: :destroy
	accepts_nested_attributes_for :invitations_sent

	has_many :invitations, as: :subject, dependent: :destroy
	accepts_nested_attributes_for :invitations

  has_many :join_requests_sent, as: :sender, class_name: "join_request"
  accepts_nested_attributes_for :join_requests_sent

  has_many :join_requests_received, as: :receiver, class_name: "join_request"
  accepts_nested_attributes_for :join_requests_received  

	def creator
		User.find_by_id(self.act_creation.creator_id) unless self.act_creation.nil?
	end

	def administrators
		@admins = []
		self.act_administrations.each do |admin|
			@admins << admin.administrator_id
		end
		User.find(@admins)
	end

	def members
		@members = []
		self.act_memberships.each do |member|
			@members << member.member_id
		end
		User.find(@members)
	end

  def inviteds
      @invited = []
      self.invitations.each do |invitation|
          @invited << invitation.invited
      end
      @invited
  end

  def joineds
      @joineds = []
      self.members.each do |joined|
          @joineds << joined
      end
      @joineds
  end


  def default_values
    self.number_of_attendings ||= 0
  end
end
