module MoonActor
    extend ActiveSupport::Concern

    included do
     
        has_many :invitations_sent, as: :inviter, class_name: "Invitation", dependent: :destroy; accepts_nested_attributes_for :invitations_sent
        has_many :invitations_received, as: :invited, class_name: "Invitation", dependent: :destroy; accepts_nested_attributes_for :invitations_sent
        has_many :join_requests_sent, as: :sender, class_name: "join_request"; accepts_nested_attributes_for :join_requests_sent  

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

# categorized features
## User
        if self.name == "User"

                # offerings
            has_many :offering_creations, foreign_key: :creator_id
            # through: :offering_creations
            has_many :events_created, through: :offering_creations, source: :offering, source_type: "Event"; accepts_nested_attributes_for :events_created
            has_many :games_created, through: :offering_creations, source: :offering, source_type: "Game"; accepts_nested_attributes_for :games_created

            has_many :offering_administrations, foreign_key: :administrator_id
            # through: :offering_administrations
            has_many :events_administrating, through: :offering_administrations, source: :offering, source_type: "Event"; accepts_nested_attributes_for :events_administrating
            has_many :games_administrating, through: :offering_administrations, source: :offering, source_type: "Game"; accepts_nested_attributes_for :games_administrating

            has_many :offering_individual_participations, foreign_key: :participator_id
            # through: :offering_individual_participations
            has_many :events_participating, through: :offering_individual_participations, source: :offering, source_type: "Event"; accepts_nested_attributes_for :events_participating
            has_many :games_participating, through: :offering_individual_participations, source: :offering, source_type: "Game"; accepts_nested_attributes_for :games_participating
                #

                # Acts
            has_many :act_creations, foreign_key: :creator_id
            # through: :act_creations
            has_many :teams_created, through: :act_creations, source: :act, source_type: "Team"; accepts_nested_attributes_for :teams_created

            has_many :act_administrations, foreign_key: :administrator_id
            # through: :act_administrations
            has_many :teams_administrating, through: :act_administrations, source: :act, source_type: "Team"; accepts_nested_attributes_for :teams_administrating

            has_many :act_memberships, foreign_key: :member_id
            # through: :act_memberships
            has_many :teams_membership, through: :act_memberships, source: :act, source_type: "Team"; accepts_nested_attributes_for :teams_membership
                #
                
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
##

## Team
        else # self.name == "Team"
            has_many :offering_team_participations, foreign_key: :participator_id
            # through: :offering_team_participations
            has_many :events_participating, through: :offering_team_participations, source: :offering, source_type: "Event"; accepts_nested_attributes_for :events_participating
            has_many :games_participating, through: :offering_team_participations, source: :offering, source_type: "Game"; accepts_nested_attributes_for :games_participating            
        end
##
#
    end

end