class OfferingSession < ActiveRecord::Base


  include PublicActivity::Model
  include Offerable
  	# location
  	# creator
  	# administrators
  include Joinable
  	# inviteds
  	# join_requests_received
  	# individual_participators
  	# team_participators (not to be used)
  	# joineds
  	# happening_case
  include Albumable     
  	# album
  	# logo

  attr_accessible :descreption, :number_of_attendings, :title, :owner_id, :owner_type

end
