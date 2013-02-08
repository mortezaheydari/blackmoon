class OfferingAdministration < ActiveRecord::Base
  attr_accessible :administrator_id, :offering_id, :offering_type

  belongs_to :offering, polymorphic: true
  belongs_to :administrator, :class_name => "User", :foreign_key => "administrator_id"  
end
