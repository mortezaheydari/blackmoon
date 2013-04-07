class JoinRequest < ActiveRecord::Base
  attr_accessible :message, :receive_type, :receiver_id, :sender_id, :sender_type

  belongs_to :sender, polymorphic: true
  accepts_nested_attributes_for :sender
  belongs_to :receiver, polymorphic: true
  accepts_nested_attributes_for :receiver

end
