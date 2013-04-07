class ActMembership < ActiveRecord::Base

  include PublicActivity::Model
  attr_accessible :act_id, :act_type, :member_id

  belongs_to :act, polymorphic: true
  belongs_to :member, :class_name => "User", :foreign_key => "member_id"  
end
