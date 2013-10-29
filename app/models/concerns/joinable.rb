module Joinable
    extend ActiveSupport::Concern

    included do



        has_many :invitations, as: :subject, dependent: :destroy; accepts_nested_attributes_for :invitations
        has_many :join_requests_received, as: :receiver, class_name: "join_request"; accepts_nested_attributes_for :join_requests_received

        def individual_participators
            @participators = []
            self.offering_individual_participations.each do |participation|
                @participators << participation.participator_id
            end
            User.find(@participators)
        end


        def inviteds
            @invited = []
            self.invitations.each do |invitation|
                    @invited << invitation.invited
            end
            @invited
        end
# categorized features

## number of sessions
### multi_session
        if ["Venue", "OtherMultiSessionOfferings"].include? self.name
            has_many :offering_sessions, as: :owner,:dependent => :destroy; accepts_nested_attributes_for :offering_sessions

            def offering_individual_participations
                @participations = []
                self.offering_sessions.all.each do |session|
                    @participations << session.individual_participation
                end
                @participations
            end

### single session
        else

        before_save :default_values

        def default_values
            if self.class.to_s == "OfferingSession"
                self.number_of_attendings ||= 1
            else
                self.number_of_attendings ||= 0
            end
        end

            has_many :offering_individual_participations, as: :offering, :dependent => :destroy; accepts_nested_attributes_for :offering_individual_participations
        end
###


## Team and Venues
        if ["Team", "Venue"].include? self.name

### Team - no_session
            if self.name == "Team"
                has_many :act_memberships, as: :act, :dependent => :destroy
                accepts_nested_attributes_for :act_memberships
                def members
                    @members = []
                    self.act_memberships.each do |member|
                        @members << member.member_id
                    end
                    User.find(@members)
                end

                def joineds
                    @joineds = []
                    self.members.each do |joined|
                            @joineds << joined
                    end
                    @joineds
                end

### Venue - multi_session
            else # self.name == "Venue"
                def joineds
                    @joineds = []
                    self.individual_participators.each do |joined|
                            @joineds << joined
                    end
                    @joineds
                end
            end
###

## other offerings - single_session
        else
            has_many :offering_team_participations, as: :offering, :dependent => :destroy; accepts_nested_attributes_for :offering_team_participations

            def team_participators
                @participators = []
                self.offering_team_participations.each do |participation|
                    @participators << participation.participator_id
                end
                Team.find(@participators)
            end

            def joineds
                @joineds = []
                self.individual_participators.each do |joined|
                        @joineds << joined
                end
                self.team_participators.each do |joined|
                        @joineds << joined
                end
                @joineds
            end

        end
##
#

# Happenable
        unless ["Team", "Venue"].include? self.name
            has_one :happening_case, as: :happening, :dependent => :destroy; accepts_nested_attributes_for :happening_case
        end
#

    end

end
