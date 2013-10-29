class Event < ActiveRecord::Base

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

  attr_accessible :category, :custom_address, :date_and_time, :descreption,
  				 :location_type, :title, :tournament_id, :duration_type, :time_from,
  				 :time_to, :fee, :fee_type, :sport, :number_of_attendings, :team_participation, :open_join

end
