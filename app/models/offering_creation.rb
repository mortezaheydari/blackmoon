class OfferingCreation < ActiveRecord::Base
  attr_accessible :creator_id, :act_id, :act_type

  belongs_to :act, polymorphic: true
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
end
