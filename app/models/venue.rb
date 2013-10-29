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
  include MultiSession
  	#
  include Albumable
  	# album
  	# logo
  	
  attr_accessible :descreption, :title, :location


end
