class Invitation < ActiveRecord::Base
  
  include PublicActivity::Model    
  attr_accessible :invited_id, :invited_type, :inviter_id, :inviter_type, :message, :response_datetime, :state, :subject_id, :subject_type, :submission_datetime

  belongs_to :inviter, polymorphic: true
  accepts_nested_attributes_for :inviter
  belongs_to :invited, polymorphic: true
  accepts_nested_attributes_for :invited
  belongs_to :subject, polymorphic: true    
  accepts_nested_attributes_for :subject  

  validates :inviter_id, presence: true
  validates :invited_id, presence: true
  validates :subject_id, presence: true  

end
