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

  attr_accessible :category, :custom_address, :date_and_time, :description, :duration_type,
  	:fee, :fee_type, :location_type, :number_of_attendings, :sport,
  	:team_participation, :time_from, :time_to, :title, :tournament_id, :open_join


end
