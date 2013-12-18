class HappeningSchedule < ActiveRecord::Base
  attr_accessible :date_and_time, :email_delivered, :happening_case_id, :user_id, :delivery_failure_count
  belongs_to :user, :dependent => :destroy; accepts_nested_attributes_for :user  
  belongs_to :happening_case, :dependent => :destroy; accepts_nested_attributes_for :happening_case
end
