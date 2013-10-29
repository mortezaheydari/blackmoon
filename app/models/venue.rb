class Venue < ActiveRecord::Base
  attr_accessible :descreption, :title, :location

  include PublicActivity::Model
  include Offerable
  include Albumable
  include Joinable
  include MultiSession

## MultiSession
#  has_many :offering_sessions, as: :owner,:dependent => :destroy
#  accepts_nested_attributes_for :offering_sessions

## Albumable
#  has_one :album, as: :owner, :dependent => :destroy
#  accepts_nested_attributes_for :album
#
#  has_one :logo, as: :owner, :dependent => :destroy
#  accepts_nested_attributes_for :logo
#
#  after_create do |venue|
#    venue.create_album if venue.album.nil?
#    venue.create_logo if venue.logo.nil?
#  end


## Offerable
#  has_one :location, as: :owner, :dependent => :destroy
#  accepts_nested_attributes_for :location
#
#  make_flaggable :like
#  has_one :offering_creation, as: :offering, :dependent => :destroy
#  accepts_nested_attributes_for :offering_creation
#
#  has_many :offering_administrations, as: :offering, :dependent => :destroy
#  accepts_nested_attributes_for :offering_administrations
#
#  def creator
#    User.find_by_id(self.offering_creation.creator_id) unless self.offering_creation.nil?
#  end
#
#  def administrators
#    @admins = []
#    self.offering_administrations.each do |admin|
#      @admins << admin.administrator_id
#    end
#    User.find(@admins)
#  end



## joinable
#  def offering_individual_participation
#    @participations = []
#    self.offering_sessions.all.each do |session|
#      @participations << session.individual_participation
#    end
#    @participations
#  end

end
