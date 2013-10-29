class User < ActiveRecord::Base

  include PublicActivity::Model
  include Albumable
    # album
    # logo
  include MoonActor
    # invitations_sent
    # invitations_received
    # join_requests_sent
    
    # offerings_participating   
    # games_participating
    # events_participating

    # offerings_administrating
    # games_administrating
    # events_administrating

    # offerings_created
    # games_created
    # events_created

    # teams_created
    # teams_administrating
    # teams_membership

  attr_accessible :name, :profile_attributes
  validates :name, presence: true, length: {maximum: 50}, uniqueness: true

  make_flagger

  after_create do |user|
    user.create_profile if user.profile.nil?
  end

  belongs_to :account
  has_one :profile, :dependent => :destroy
  accepts_nested_attributes_for :profile

## Followers
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, class_name: "Relationship", :foreign_key => "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
##

  def title
    if profile.first_name || profile.last_name
      profile.first_name+" "+profile.last_name
    else
      name
    end
  end

end
