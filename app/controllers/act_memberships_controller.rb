class ActMembershipsController < ApplicationController
	include SessionsHelper
	before_filter :authenticate_account!

	# getting membership in an act
	## note:  process is open to everybody now. to be controlled by act admin later

	def create
		act_type = params[:offering_type]
		user = User.find_by_id(params[:joining_user])
		act_id = params[:offering_id]

		if !name_is_valid?(user, act_type); raise Errors::FlowError.new(send("#{act_type}_path", offering_id), "Permission denied."); end

		acts_membership = user.send("#{act_type}s_membership")
		joining_act = act_type.camelize.constantize.find_by_id(act_id)

		unless joining_act; raise Errors::FlowError.new; end

		# gender
		if ["male", "female"].include? joining_act.gender
			unless user.gender == joining_act.gender; raise Errors::FlowError.new(root_path, "This #{act_type} is #{joining_act.gender} only."); end
		end

		number_of_attendings = joining_act.number_of_attendings
		if acts_membership.count < number_of_attendings or number_of_attendings == 0
			acts_membership << joining_act
		else
			raise Errors::FlowError.new(send("#{act_type}_path", offering_id), "Permission denied.")
		end
		@offering = joining_act
		@members = joining_act.members
		joining_act.create_activity :create, owner: user

		respond_to do |format|
			format.html { redirect_to joining_act }
			format.js
		end
	end

	def destroy
		act_type = params[:offering_type]
		user = User.find_by_id(params[:leaving_user])
		act_id = params[:offering_id]

		if !name_is_valid?(user, act_type); raise Errors::FlowError.new(send("#{act_type}_path", offering_id), "Permission denied."); end

		acts_memberships = user.act_memberships.where(act_type: act_type, act_id: act_id)

		unless acts_memberships; raise Errors::FlowError.new; end

		acts_memberships.each.destroy unless acts_memberships == []

		leaving_act = act.camelize.constantize.find_by_id(act_id)
		leaving_act.create_activity :destroy, owner: user

		@members = leaving_act.members
		respond_to do |format|
			format.html { redirect_to leaving_act }
			format.js
		end
	end

	private
		# checks if offering name is valid for team
		# note: this function is controller specific
		def name_is_valid?(user, name)
			user.respond_to? "#{name}s_membership" and this_is_act?(name)
		end
end