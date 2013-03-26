class User < ActiveRecord::Base
  attr_accessible :name, :profile_attributes
  validates :name, presence: true, length: {maximum: 50}, uniqueness: true

  make_flagger


  after_create do |user|
        user.create_profile if user.profile.nil?
        user.create_album if user.album.nil?
        user.create_logo if user.logo.nil?
  end

  has_one :profile, :dependent => :destroy
  accepts_nested_attributes_for :profile
  has_one :album, as: :owner, :dependent => :destroy
  accepts_nested_attributes_for :album
  has_one :logo, as: :owner, :dependent => :destroy
  accepts_nested_attributes_for :logo
## Offerings

      # A - offering creations:
  has_many :offering_creations, foreign_key: :creator_id
      #   1.events created
  has_many :events_created, through: :offering_creations, source: :offering, source_type: "Event"
  accepts_nested_attributes_for :events_created
      #   2.games created
  has_many :games_created, through: :offering_creations, source: :offering, source_type: "Game"
  accepts_nested_attributes_for :games_created

      # B - offering administrations:
  has_many :offering_administrations, foreign_key: :administrator_id
      #   1.events administrating
  has_many :events_administrating, through: :offering_administrations, source: :offering, source_type: "Event"
  accepts_nested_attributes_for :events_administrating
      #   2.games administrating
  has_many :games_administrating, through: :offering_administrations, source: :offering, source_type: "Game"
  accepts_nested_attributes_for :games_administrating

      # C - offering participation:
  has_many :offering_individual_participations, foreign_key: :participator_id
      #   1.events participating
  has_many :events_participating, through: :offering_individual_participations, source: :offering, source_type: "Event"
  accepts_nested_attributes_for :events_participating
      #   2.games participating
  has_many :games_participating, through: :offering_individual_participations, source: :offering, source_type: "Game"
  accepts_nested_attributes_for :games_participating

  accepts_nested_attributes_for :profile
  belongs_to :account

## Acts

      # D - Act creation
  has_many :act_creations, foreign_key: :creator_id
      #   1.teams created
  has_many :teams_created, through: :act_creations, source: :act, source_type: "Team"
  accepts_nested_attributes_for :teams_created

      # F - act administrations:
  has_many :act_administrations, foreign_key: :administrator_id
      #   1.team administrating
  has_many :teams_administrating, through: :act_administrations, source: :act, source_type: "Team"
  accepts_nested_attributes_for :teams_administrating

      # G - act memberships:
  has_many :act_memberships, foreign_key: :member_id
      #   1.team memberships
  has_many :teams_membership, through: :act_memberships, source: :act, source_type: "Team"
  accepts_nested_attributes_for :teams_membership


## Followers

      # E - follow relationship
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


## invitations
      # F - invitations as invited and inviter
  has_many :invitations_sent, as: :inviter, class_name: "Invitation", dependent: :destroy
  accepts_nested_attributes_for :invitations_sent  
  has_many :invitations_received, as: :invited, class_name: "Invitation", dependent: :destroy
  accepts_nested_attributes_for :invitations_sent
##



    def offerings_participating
        @participatings = []
        events_participating.each do |event_participating|
            @participatings << event_participating
        end
        games_participating.each do |game_participating|
            @participatings << game_participating
        end
        @participatings
    end


    def offerings_administrating
        @administratings = []
        events_administrating.each do |event_administrating|
            @administratings << event_administrating
        end
        games_administrating.each do |game_administrating|
            @administratings << game_administrating
        end
        @administratings
    end

    def offerings_created
        @createds = []
        events_created.each do |event_created|
            @createds << event_created
        end
        games_created.each do |game_created|
            @createds << game_created
        end
        @createds
    end
end
