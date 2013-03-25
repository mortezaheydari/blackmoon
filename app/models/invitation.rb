class Invitation < ActiveRecord::Base
  attr_accessible :invited_id, :invited_type, :inviter_id, :inviter_type, :message, :response_datetime, :state, :subject_id, :subject_type, :submission_datetime

  belongs_to :inviter, polymorphic: true
  belongs_to :invited, polymorphic: true
  belongs_to :subject, polymorphic: true    

end
