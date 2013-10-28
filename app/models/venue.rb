class Venue < ActiveRecord::Base
  attr_accessible :descreption, :title, :location

  include PublicActivity::Model

  after_create do |venue|
    venue.create_album if venue.album.nil?
    venue.create_logo if venue.logo.nil?
  end

  make_flaggable :like

  has_many :offering_sessions, as: :owner,:dependent => :destroy
  accepts_nested_attributes_for :offering_sessions

  has_one :location, as: :owner, :dependent => :destroy
  accepts_nested_attributes_for :location

  has_one :album, as: :owner, :dependent => :destroy
  accepts_nested_attributes_for :album

  has_one :logo, as: :owner, :dependent => :destroy
  accepts_nested_attributes_for :logo

  has_one :offering_creation, as: :offering, :dependent => :destroy
  accepts_nested_attributes_for :offering_creation

  has_many :offering_administrations, as: :offering, :dependent => :destroy
  accepts_nested_attributes_for :offering_administrations

  has_many :invitations, as: :subject, dependent: :destroy
  accepts_nested_attributes_for :invitations

  has_many :join_requests_received, as: :receiver, class_name: "join_request"
  accepts_nested_attributes_for :join_requests_received

  def offering_individual_participation
    @participations = []    
    self.offering_sessions.all.each do |session|
      @participations << session.individual_participation
    end
    @participations
  end

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

  def inviteds
      @invited = []
      self.invitations.each do |invitation|
          @invited << invitation.invited
      end
      @invited
  end

  def joineds
      @joineds = []
      self.sessions.each do |joined|
          @joineds << joined
      end
      self.team_participators.each do |joined|
          @joineds << joined
      end
      @joineds
  end

end
