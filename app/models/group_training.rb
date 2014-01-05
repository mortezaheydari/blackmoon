class GroupTraining < ActiveRecord::Base

  include PublicActivity::Model
  include Offerable
    # city
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

  # include OfferingSearchable

  attr_accessible :descreption, :title, :location, :gender, :city

  attr_accessor :updated_at

    searchable do
      text :title, :boost => 5
      text :descreption
      date :updated_at
      string :city
      string :gender    

    end
end
