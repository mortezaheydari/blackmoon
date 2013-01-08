class User < ActiveRecord::Base
  attr_accessible :name, :profile_attributes
  validates :name, presence: true, length: {maximum: 50}, uniqueness: true

  after_create do |user|
    if user.profile.nil?
    	user.create_profile
    end
  end

  has_one :profile
  has_many :offering_creations, foreign_key: :creator_id
  has_many :events_created, through: :offering_creations, source: :offering, source_type: "Event"

  accepts_nested_attributes_for :profile  
  belongs_to :account
end
