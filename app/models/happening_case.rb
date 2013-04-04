class HappeningCase < ActiveRecord::Base

  include PublicActivity::Model  
  attr_accessible :date_and_time, :duration_type, :happening_id, :happening_type, :time_from, :time_to, :title

  belongs_to :happening, polymorphic: true
  accepts_nested_attributes_for :happening

  validates :date_and_time, presence: true
  validates :duration_type, presence: true

end
