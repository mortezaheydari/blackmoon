class Team < ActiveRecord::Base

  include PublicActivity::Model
  include Offerable
	# creator
	# administrators
  include Joinable
	# inviteds
	# join_requests_received
	# individual_participators
	# joineds
	# happening_case
  include Albumable
	# album
	# logo
  include MoonActor
	# invitations_sent
	# invitations_received
	# join_requests_sent

	# offerings_participating  	
	# games_participating
	# events_participating


  attr_accessible :descreption, :name, :sport, :number_of_attendings, :title, :category, :open_join

end
