# controller responsible for joining buttons
class OfferingIndividualParticipationsController < ApplicationController
  include SessionsHelper

	before_filter :authenticate_account!

  def index
    # temp fix
  end

  # joining an offering
  def create
    offering_type = params[:offering_type]
    user = User.find_by_id(params[:joining_user])
    offering_id = params[:offering_id]

    double_check_name_is_valid(user, offering_type)

    offerings_participating = user.send("#{offering_type}s_participating")
    joining_offering = offering_type.camelize.constantize.find_by_id(offering_id)
    number_of_attendings = joining_offering.number_of_attendings
    if offerings_participating.count < number_of_attendings or number_of_attendings == 0
        # todo: check participation deadline is not pass
        offerings_participating << joining_offering unless offerings_participating.include? joining_offering
        joining_offering.create_activity key: "offering_individual_participation.create", owner: current_user, recipient: user
    end
    @participator = joining_offering.individual_participators
    @offering = joining_offering
    respond_to do |format|
        format.html { redirect_to joining_offering }
        format.js
    end
  end

  # leaving an offering
  def destroy

    offering_type = params[:offering_type]
    user = User.find_by_id(params[:leaving_user])
    offering_id = params[:offering_id]

    double_check_name_is_valid(user, offering_type)
    participations = user.offering_individual_participations.where(offering_type: offering_type, offering_id: offering_id)
    # todo: check participation deadline is not pass

    participations.each.destroy unless participations == []

    leaving_offering = offering.camelize.constantize.find_by_id(offering_id)
    leaving_offering.create_activity key: "offering_individual_participation.destroy", owner: current_user, recipient: user   

    @participator = leaving_offering.individual_participators
    respond_to do |format|
        format.html { redirect_to leaving_offering }
        format.js
    end

  end

  private

    # checks if offering name is valid for user
    # note: this function is controller specific
    def name_is_valid?(user, name)
      user.respond_to? "#{name}s_participating" and ["event","class","game"].include? name
    end

    def double_check_name_is_valid(user, name)
      redirect_to rooth_path and return unless name_is_valid?(user, name)
    end
end
