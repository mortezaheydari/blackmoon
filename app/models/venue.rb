class Venue < ActiveRecord::Base
  attr_accessible :descreption, :title, :location

  include PublicActivity::Model

  after_create do |event|
    event.create_album if event.album.nil?
    event.create_logo if event.logo.nil?
  end

  make_flaggable :like

  has_one :location, as: :owner, class_name: "location", :dependent => :destroy
  accepts_nested_attributes_for :location

  has_one :album, as: :owner, :dependent => :destroy
  accepts_nested_attributes_for :album

  has_one :logo, as: :owner, :dependent => :destroy
  accepts_nested_attributes_for :logo

  has_one :offering_creation, as: :offering, :dependent => :destroy
  accepts_nested_attributes_for :offering_creation

  has_many :offering_administrations, as: :offering, :dependent => :destroy
  accepts_nested_attributes_for :offering_administrations

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

end
