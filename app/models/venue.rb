class Venue < ActiveRecord::Base

  include PublicActivity::Model
  include Offerable
  	# location
  	# creator
  	# administrators
  include MultiSessionJoinable
  	# offering_sessions
  	# happening_cases
    # joineds
    # join_requests_received    
    # individual_participators
    # invitations

  include Albumable
  	# album
  	# logo

  attr_accessible :descreption, :title, :location

  has_many :collectives, as: :owner, :dependent => :destroy; accepts_nested_attributes_for :collectives

end
