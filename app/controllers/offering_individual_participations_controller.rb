class OfferingIndividualParticipationsController < ApplicationController
            include SessionsHelper

	before_filter :authenticate_account!

            def index

            end

  def create
      offering = params[:offering_type]
      user = User.find_by_id(params[:joining_user])
      offering_id = params[:offering_id]

      if user.respond_to? "#{offering}s_participating" and ["event","class","game"].include? offering

          offerings_participating = user.send("#{offering}s_participating")
          joining_offering = offering.camelize.constantize.find_by_id(offering_id)
          number_of_attendings = joining_offering.number_of_attendings
          if offerings_participating.count < number_of_attendings or number_of_attendings = 0
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

	# def destroy
	# 	@offering_type = params[offering_type]
	# 	@offering_id = params[offering_id]
	# 	@user = params[leaving_user]
	# 	@offering = @user.offering_individual_participations.where(offering_type: @offering_type, offering_id: @offering_id)
	# 	@offering.destroy unless @offering == []

	# 	# respond_to do |format|
	# 	# 	format.html { redirect_to @user }
	# 	# 	format.js
	# 	# end
	# end

	# private
	# 	def get_offering(offering_type)
	# 		params[:event] if offering_type = "event"		
	# 	end

	# 	def join_event
	# 		if events_participating.count < number_of_attendings or number_of_attendings = 0
	# 		events_participating << Event.find_by_id(@offering_id)


end
