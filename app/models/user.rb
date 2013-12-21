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
    # offering_sessions_participating

    # offerings_administrating
    # games_administrating
    # events_administrating

    # offerings_created
    # games_created
    # events_created

    # teams_created
    # teams_administrating
    # teams_membership

  attr_accessible :name, :profile_attributes, :gender, :moonactor_ability_attributes
  validates :name, presence: true, length: {maximum: 50}, uniqueness: true

  make_flagger

  after_create do |user|
    user.create_profile if user.profile.nil?
    user.create_moonactor_ability if user.moonactor_ability.nil?    
  end

  has_many :happening_schedules, :dependent => :destroy; accepts_nested_attributes_for :happening_schedules
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
    title = ""
    if !profile.first_name.nil? && !profile.last_name.nil?
        title = (profile.first_name.capitalize+" "+profile.last_name.capitalize)
    end
    title = self.name if title.tr(' ', '').empty?
    title
  end

  def wants_daily_emails?
    self.profile.daily_email_option
  end
end
