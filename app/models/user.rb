class User < ActiveRecord::Base
  attr_accessible :name, :profile_attributes
  validates :name, presence: true, length: {maximum: 50}, uniqueness: true

  after_create do |user|
    if user.profile.nil?
    	user.create_profile
    end
  end

  has_one :profile, :dependent => :destroy
  
  # offering creations:
  has_many :offering_creations, foreign_key: :creator_id
  #   1.events created
  has_many :events_created, through: :offering_creations, source: :offering, source_type: "Event"
  accepts_nested_attributes_for :events_created
  #   2.games created
  ##  has_many :games_created, through: :offering_creations, source: :offering, source_type: "Game"
  ##  accepts_nested_attributes_for :games_created

  accepts_nested_attributes_for :profile  
  belongs_to :account

end
