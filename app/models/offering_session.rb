class OfferingSession < ActiveRecord::Base
  attr_accessible :descreption, :number_of_attendings, :title, :owner_id, :owner_type

  include PublicActivity::Model
  include SessionOfferable
  include Joinable
  include Albumable     

## Joinable
#  before_save :default_values
#  has_many :join_requests_received, as: :receiver, class_name: "join_request"
#  accepts_nested_attributes_for :join_requests_received
#
#  has_many :invitations, as: :subject, dependent: :destroy
#  accepts_nested_attributes_for :invitations
#
#  has_many :offering_individual_participations, as: :offering, :dependent => :destroy
#  accepts_nested_attributes_for :offering_individual_participations
#
#  has_one :happening_case, as: :happening, :dependent => :destroy
#  accepts_nested_attributes_for :happening_case
#
#  def individual_participators
#    @participators = []
#    self.offering_individual_participations.each do |participation|
#      @participators << participation.participator_id
#    end
#    User.find(@participators)
#  end
#
#  def inviteds
#      @invited = []
#      self.invitations.each do |invitation|
#          @invited << invitation.invited
#      end
#      @invited
#  end
#
#  def joineds
#      @joineds = []
#      self.individual_participators.each do |joined|
#          @joineds << joined
#      end
#      self.team_participators.each do |joined|
#          @joineds << joined
#      end
#      @joineds
#  end
#
#  def default_values
#    self.number_of_attendings ||= 1
#  end

## SessionOfferable
#  belongs_to :owner, polymorphic: true
#  accepts_nested_attributes_for :owner
#
#  def administrators
#    @admins = []
#    owner.offering_administrations.each do |admin|
#      @admins << admin.administrator_id
#    end
#    User.find(@admins)
#  end
#
#  def creator
#    User.find_by_id(owner.offering_creation.creator_id) unless owner.offering_creation.nil?
#  end
#
#
#  def location
#    owner.location
#  end

end
