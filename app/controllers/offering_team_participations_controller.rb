class OfferingTeamParticipationsController < ApplicationController
  include SessionsHelper

	before_filter :authenticate_account!


  def index
    # temp fix
  end

  # joining an offering
  def create
      offering_type = params[:offering_type]
      team = Team.find_by_id(params[:joining_team])
      offering_id = params[:offering_id]

      if name_is_valid?(team, offering_type)

        offerings_participating = team.send("#{offering_type}s_participating")
        joining_offering = offering_type.camelize.constantize.find_by_id(offering_id)
        number_of_attendings = joining_offering.number_of_attendings
        if offerings_participating.count < number_of_attendings or number_of_attendings == 0
            # todo: check participation deadline is not pass
            offerings_participating << joining_offering
        end
        @participator = joining_offering.team_participators
        respond_to do |format|
            format.html { redirect_to joining_offering }
            format.js
        end
      else
          redirect_to root
      end
  end

  # leaving an offering
  def destroy
      offering_type = params[:offering_type]
      team = Team.find_by_id(params[:leaving_team])
      offering_id = params[:offering_id]

      if name_is_valid?(team, offering_type)
      participations = team.offering_team_participations.where(offering_type: offering_type, offering_id: offering_id)
      # todo: check participation deadline is not pass
      participations.each.destroy unless participations == []

        leaving_offering = offering.camelize.constantize.find_by_id(offering_id)
        @participator = leaving_offering.team_participators
        respond_to do |format|
            format.html { redirect_to leaving_offering }
            format.js
        end
      else
          redirect_to root
      end    
  end

  private

    # checks if offering name is valid for team
    # note: this function is controller specific
    def name_is_valid?(team, name)
      team.respond_to? "#{name}s_participating" and ["event","class","game"].include? name
    end


end
