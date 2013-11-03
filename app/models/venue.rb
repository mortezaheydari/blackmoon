class Venue < ActiveRecord::Base

  include PublicActivity::Model
  include Offerable
  	# location
  	# creator
  	# administrators
  include Joinable
  	# offering_sessions
  	# inviteds
  	# individual_participators
  include Albumable
  	# album
  	# logo
  	
  attr_accessible :descreption, :title, :location

  has_many :offering_sessions, as: :owner, :dependent => :destroy; accepts_nested_attributes_for :offering_sessions
  has_many :collectives, as: :owner, :dependent => :destroy; accepts_nested_attributes_for :collective

end
