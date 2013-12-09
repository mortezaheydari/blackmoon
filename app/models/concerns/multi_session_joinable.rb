module MultiSessionJoinable
  extend ActiveSupport::Concern

  included do

    has_many :offering_sessions, as: :owner,:dependent => :destroy; accepts_nested_attributes_for :offering_sessions
    has_many :collectives, as: :owner, :dependent => :destroy; accepts_nested_attributes_for :collectives
    def offering_individual_participations
        @participations = []
        self.offering_sessions.all.each do |session|
            @participations << session.individual_participation
        end
        @participations
    end 

    def happening_cases
        @happening_cases = []
        self.offering_sessions.each do |offering_session|
            @happening_cases << offering_session.happening_case
        end
        @happening_cases
    end

    def joineds
        @joineds = []
        self.individual_participators.each do |joined|
                @joineds << joined
        end
        @joineds
    end

    def individual_participators
        @participators = []
        self.offering_individual_participations.each do |participation|
            @participators << participation.participator_id
        end
        User.find(@participators)
    end

    #REFACTORE: possibly deprecated
    has_many :invitations, as: :subject, dependent: :destroy; accepts_nested_attributes_for :invitations
    has_many :join_requests_received, as: :receiver, class_name: "join_request"; accepts_nested_attributes_for :join_requests_received


  end

end