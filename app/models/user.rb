class User < ActiveRecord::Base
  attr_accessible :name, :profile_attributes
  validates :name, presence: true, length: {maximum: 50}, uniqueness: true

  make_flagger


  after_create do |user|
    if user.profile.nil?
    	user.create_profile
    end
  end

  has_one :profile, :dependent => :destroy

  # A - offering creations:
  has_many :offering_creations, foreign_key: :creator_id
  #   1.events created
  has_many :events_created, through: :offering_creations, source: :offering, source_type: "Event"
  accepts_nested_attributes_for :events_created
  #   2.games created
  ##  has_many :games_created, through: :offering_creations, source: :offering, source_type: "Game"
  ##  accepts_nested_attributes_for :games_created

  # B - offering administrations:
  has_many :offering_administrations, foreign_key: :administrator_id
  #   1.events administrating
  has_many :events_administrating, through: :offering_administrations, source: :offering, source_type: "Event"
  accepts_nested_attributes_for :events_administrating

  # C - offering participation:
  has_many :offering_individual_participations, foreign_key: :participator_id
  #   1.events participating
  has_many :events_participating, through: :offering_individual_participations, source: :offering, source_type: "Event"
  accepts_nested_attributes_for :events_participating

  accepts_nested_attributes_for :profile
  belongs_to :account

  # D - follow relationship
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, class_name: "Relationship", :foreign_key => "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  # E - Act creation
  has_many :act_creations, foreign_key: :creator_id
  #   1.teams created
  has_many :teams_created, through: :act_creations, source: :act, source_type: "Team"
  accepts_nested_attributes_for :teams_created


  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

end
