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
		
		if !name_is_valid?(user, offering_type); raise Errors::FlowError.new; end

		offerings_participating = user.send("#{offering_type}s_participating")

		joining_offering = offering_type.camelize.constantize.find_by_id(offering_id)

		# gender restriction		
		if joining_offering.class.to_s == "OfferingSession"
			if ["male", "female"].include? joining_offering.owner.gender
				unless user.gender == joining_offering.owner.gender; raise Errors::FlowError.new(root_path, "This action is not possible because of gender restriction."); end
			end
		else
			if ["male", "female"].include? joining_offering.gender
				unless user.gender == joining_offering.gender; raise Errors::FlowError.new(root_path, "This action is not possible because of gender restriction."); end
			end
		end

		number_of_attendings = joining_offering.number_of_attendings
		if offerings_participating.count < number_of_attendings or number_of_attendings == 0
			# TODO: check participation deadline is not pass
			offerings_participating << joining_offering unless offerings_participating.include? joining_offering
			joining_offering.create_activity key: "offering_individual_participation.create", owner: current_user, recipient: user

			# create happening_scheduled
			happening_case = joining_offering.happening_case
			happ_sch = HappeningSchedule.new
			happ_sch.happening_case_id = happening_case.id
			happ_sch.user_id = user.id
			if happening_case.duration_type = "All Day"
				happ_sch.date_and_time = happening_case.date_and_time
			else
				d = happening_case.date_and_time
				t = happening_case.time_from
				happ_sch.date_and_time = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec)
			end
			happ_sch.save
			#
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

		if !name_is_valid?(user, offering_type); raise Errors::FlowError.new; end
		participations = user.offering_individual_participations.where(offering_type: offering_type, offering_id: offering_id)
		# todo: check participation deadline is not pass

		participations.each.destroy unless participations == []

		leaving_offering = offering.camelize.constantize.find_by_id(offering_id)
		# destroy happening_schedule
		happ_schs = HappeningSchedule.where("user_id = ? AND happening_case_id = ?", user.id, leaving_offering.happening_case.id)
		happ_schs.each.destroy unless happ_schs == []
		# 

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
			user.respond_to? "#{name}s_participating" and ["event","class","game", "offering_session", "personal_trainer", "group_training"].include? name.underscore
		end

end
