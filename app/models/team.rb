class Team < ActiveRecord::Base

  include PublicActivity::Model
  include Offerable
	# creator
	# administrators
  include Joinable
	# inviteds
	# join_requests_received
	# individual_participators
	# members
	# joineds
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

  # include OfferingSearchable

  attr_accessible :descreption, :sport, :number_of_attendings, :title, :category, :open_join, :gender

  attr_accessor :updated_at

	searchable do
		text :title, :boost => 5
		text :descreption
		# string :fee_type
		string :sport
		date :updated_at
	end

end
