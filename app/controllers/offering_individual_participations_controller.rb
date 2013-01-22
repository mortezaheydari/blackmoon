class OfferingIndividualParticipationsController < ApplicationController

	before_filter :authenticate_account!

	def create
		@offering_type = params[offering_type]
		@offering_id = params[offering_id]
		@user = params[joining_user]
		if @offering_type = "event"		
			@user.events_participating << Event.find_by_id(@offering_id)
		end
		# respond_to do |format|
		# 	format.html { redirect_to @user }
		# 	format.js
		# end
	end

	def destroy
		@offering_type = params[offering_type]
		@offering_id = params[offering_id]
		@user = params[leaving_user]
		@offering = @user.offering_individual_participations.where(offering_type: @offering_type, offering_id: @offering_id)
		@offering.destroy unless @offering == []

		# respond_to do |format|
		# 	format.html { redirect_to @user }
		# 	format.js
		# end
	end

end
