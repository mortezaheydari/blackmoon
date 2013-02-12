class OfferingTeamParticipation < ActiveRecord::Base
  attr_accessible :offering_id, :offering_type, :participator_id
  belongs_to :offering, polymorphic: true
  belongs_to :participator, :class_name => "Team", :foreign_key => "participator_id"    
end
