class OfferingAdministration < ActiveRecord::Base
  attr_accessible :administrator_id, :creator_id, :offering_type, :offering_id

  belongs_to :offering, polymorphic: true
  belongs_to :administrator, :class_name => "User", :foreign_key => "administrator_id"  
end
