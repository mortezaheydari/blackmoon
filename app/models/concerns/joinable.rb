module Joinable
  extend ActiveSupport::Concern

  included do

    has_many :offering_individual_participations, as: :offering, :dependent => :destroy
    accepts_nested_attributes_for :offering_individual_participations

    has_many :offering_team_participations, as: :offering, :dependent => :destroy
    accepts_nested_attributes_for :offering_team_participations

    has_many :invitations, as: :subject, dependent: :destroy
    accepts_nested_attributes_for :invitations

    has_one :happening_case, as: :happening, :dependent => :destroy
    accepts_nested_attributes_for :happening_case

    has_many :join_requests_received, as: :receiver, class_name: "join_request"
    accepts_nested_attributes_for :join_requests_received

    def individual_participators
      @participators = []
      self.offering_individual_participations.each do |participation|
        @participators << participation.participator_id
      end
      User.find(@participators)
    end

    def team_participators
      @participators = []
      self.offering_team_participations.each do |participation|
        @participators << participation.participator_id
      end
      Team.find(@participators)
    end

    def inviteds
        @invited = []
        self.invitations.each do |invitation|
            @invited << invitation.invited
        end
        @invited
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

    def default_values
      if self.class == "OfferingSession"
        self.number_of_attendings ||= 1
      else
        self.number_of_attendings ||= 0
      end
    end

  end

 end