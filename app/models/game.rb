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

  attr_accessible :category, :custom_address, :description,
  	:fee, :fee_type, :location_type, :number_of_attendings, :sport,
  	:team_participation, :title, :tournament_id, :open_join, :location

    searchable do
        text :title, :boost => 5
        text :description
        # string :fee_type
        string :sport
        boolean :team_participation
    end

end