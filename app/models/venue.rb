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
    # collectives

  include Albumable
  	# album
  	# logo

  attr_accessible :descreption, :title, :location, :updated_at

    searchable do
        text :title, :boost => 5
        text :descreption
        date :updated_at
    end
end
