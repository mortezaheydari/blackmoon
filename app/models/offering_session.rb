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

  attr_accessible :descreption, :number_of_attendings, :title, :owner_id, :owner_type, :collective_id, :collection_flag, :collective_type, :repeat_duration, :repeat_number, :repeat_every
  # belongs_to :collective; accepts_nested_attributes_for :collective

  def collective_type
    if self.collective_id.nil?
        return "none"
    else
        return "existing"
    end
  end

  def repeat_duration
    "hour"
  end

  def repeat_number
    1
  end

  def repeat_every
      1
  end
end
