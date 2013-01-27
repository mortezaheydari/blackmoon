# controller responsible for joining buttons
class OfferingIndividualParticipationsController < ApplicationController
  include SessionsHelper

	before_filter :authenticate_account!

  def index
    # temp fix
  end

  # joining an offering
  def create
      offering = params[:offering_type]
      user = User.find_by_id(params[:joining_user])
      offering_id = params[:offering_id]

      if name_is_valid?(user, offering)

        offerings_participating = user.send("#{offering}s_participating")
        joining_offering = offering.camelize.constantize.find_by_id(offering_id)
        number_of_attendings = joining_offering.number_of_attendings
        if offerings_participating.count < number_of_attendings or number_of_attendings = 0
            # todo: check participation deadline is not pass
            offerings_participating << joining_offering
        end
        @participator = joining_offering.individual_participators
        respond_to do |format|
            format.html { redirect_to joining_offering }
            format.js
        end
      else
          redirect_to @user
      end
  end

  # leaving an offering
  def destroy
      offering = params[:offering_type]
      user = User.find_by_id(params[:leaving_user])
      offering_id = params[:offering_id]

      if name_is_valid?(user, offering)
      participations = user.offering_individual_participations.where(offering_type: offering, offering_id: offerign_id)
      # todo: check participation deadline is not pass
      participations.each.destroy unless participations == []

        leaving_offering = offering.camelize.constantize.find_by_id(offering_id)
        @participator = leaving_offering.individual_participators
        respond_to do |format|
            format.html { redirect_to leaving_offering }
            format.js
        end
      else
          redirect_to @user
      end    
  end

  private

    # checks if offerign name is valid for user
    # note: this function is controller specific
    def name_is_valid?(user, name)
      user.respond_to? "#{name}s_participating" and ["event","class","game"].include? name
    end

end
