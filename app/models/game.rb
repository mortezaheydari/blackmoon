class Game < ActiveRecord::Base

  include PublicActivity::Model

  include Offerable
  	# location
  	# creator
  	# administrators
  include Joinable
  	# inviteds
  	# join_requests_received
  	# individual_participators
  	# team_participators
  	# joineds
  	# happening_case
  include Albumable
  	# album
  	# logo
    
  include OfferingSearchable

  attr_accessible :category, :custom_address, :description,
  	:fee, :fee_type, :location_type, :number_of_attendings, :sport,
  	:team_participation, :title, :tournament_id, :open_join, :location


end