module Joinable
    extend ActiveSupport::Concern

    included do

        has_many :invitations, as: :subject, dependent: :destroy; accepts_nested_attributes_for :invitations
        has_many :join_requests_received, as: :receiver, class_name: "join_request"; accepts_nested_attributes_for :join_requests_received
        has_many :offering_individual_participations, as: :offering, :dependent => :destroy; accepts_nested_attributes_for :offering_individual_participations

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

        before_save :default_values

        def default_values
            if self.class.to_s == "OfferingSession"
                self.number_of_attendings ||= 1
            else
                self.number_of_attendings ||= 0
            end
        end

        unless "Team" == self.name

            has_many :offering_team_participations, as: :offering, :dependent => :destroy; accepts_nested_attributes_for :offering_team_participations
            has_one :happening_case, as: :happening, :dependent => :destroy; accepts_nested_attributes_for :happening_case

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

            def open_to_edit?
                count = self.joineds.count + self.inviteds.count
                count == 0
            end

            def full?
                self.joineds.count >= self.number_of_attendings
            end

## Team:
        else
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
        end
    end
end
