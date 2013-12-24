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
        def pending_invitations
            Invitation.where("invited_id = ? AND invited_type = ? AND  state = ?", self.id, self.class.to_s, "sent")
        end
        def pending_invitations?
            !self.pending_invitations.empty?
        end

# categorized features
## User
        if self.name == "User"

                # offerings
            has_many :offering_creations, foreign_key: :creator_id
            # through: :offering_creations
            has_many :events_created, through: :offering_creations, source: :offering, source_type: "Event"; accepts_nested_attributes_for :events_created
            has_many :games_created, through: :offering_creations, source: :offering, source_type: "Game"; accepts_nested_attributes_for :games_created
            has_many :venues_created, through: :offering_creations, source: :offering, source_type: "Venue"; accepts_nested_attributes_for :venues_created
            has_many :personal_trainers_created, through: :offering_creations, source: :offering, source_type: "PersonalTrainer"; accepts_nested_attributes_for :personal_trainers_created
            has_many :group_trainings_created, through: :offering_creations, source: :offering, source_type: "GroupTraining"; accepts_nested_attributes_for :group_trainings_created

            has_many :offering_administrations, foreign_key: :administrator_id
            # through: :offering_administrations
            has_many :events_administrating, through: :offering_administrations, source: :offering, source_type: "Event"; accepts_nested_attributes_for :events_administrating
            has_many :games_administrating, through: :offering_administrations, source: :offering, source_type: "Game"; accepts_nested_attributes_for :games_administrating
            has_many :venues_administrating, through: :offering_creations, source: :offering, source_type: "Venue"; accepts_nested_attributes_for :venues_administrating
            has_many :personal_trainers_administrating, through: :offering_creations, source: :offering, source_type: "PersonalTrainer"; accepts_nested_attributes_for :personal_trainers_administrating
            has_many :group_trainings_administrating, through: :offering_creations, source: :offering, source_type: "GroupTraining"; accepts_nested_attributes_for :group_trainings_administrating

            has_many :offering_individual_participations, foreign_key: :participator_id
            # through: :offering_individual_participations
            has_many :events_participating, through: :offering_individual_participations, source: :offering, source_type: "Event"; accepts_nested_attributes_for :events_participating
            has_many :games_participating, through: :offering_individual_participations, source: :offering, source_type: "Game"; accepts_nested_attributes_for :games_participating
            has_many :offering_sessions_participating, through: :offering_individual_participations, source: :offering, source_type: "OfferingSession"; accepts_nested_attributes_for :offering_sessions_participating
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
                venues_administrating.each do |venue_administrating|
                    @administratings << venue_administrating
                end
                personal_trainers_administrating.each do |personal_trainer_administrating|
                    @administratings << personal_trainer_administrating
                end
                group_trainings_administrating.each do |group_training_administrating|
                    @administratings << group_training_administrating
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
                venues_created.each do |venue_created|
                    @createds << venue_created
                end
                personal_trainers_created.each do |personal_trainer_created|
                    @createds << personal_trainer_created
                end
                group_trainings_created.each do |group_training_created|
                    @createds << group_training_created
                end
                @createds
            end

            def recent_offerings_participating(number=10)
                offerings = []                
                if self.class.to_s == "User"
                    participations = OfferingIndividualParticipation.where(participator_id: self.id).order(created_at: :desc).limit(number)
                    participations.each do |participation|
                        offerings << participation.offering
                    end
                elsif self.class.to_s == "User"
                    participations = OfferingIndividualParticipation.where(participator_id: self.id).order(created_at: :desc).limit(number)
                    participations.each do |participation|
                        offerings << participation.offering
                    end                    
                end
                offerings
            end
            
            has_one :moonactor_ability, as: :owner, dependent: :destroy; accepts_nested_attributes_for :moonactor_ability

            def can_create?(offering_name)
                return true unless ["event","game", "team", "venue", "personal_trainer", "group_training"].include? offering_name
                self.moonactor_ability.send("create_#{offering_name}")
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