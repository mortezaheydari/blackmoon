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

  attr_accessible :category, :custom_address, :descreption,
    :location_type, :title, :tournament_id, :fee, :fee_type, :sport, :number_of_attendings, :team_participation, :open_join, :updated_at


    searchable do
        text :title, :boost => 5
        text :descreption
        # string :fee_type
        string :sport
        boolean :team_participation
        date :updated_at
    end
end
