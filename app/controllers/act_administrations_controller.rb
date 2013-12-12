class ActAdministrationsController < ApplicationController
	include SessionsHelper
	before_filter :authenticate_account!

	def create
		act_type = params[:this_type]
		user = User.find_by_id(params[:admin_id_added])
		act_id = params[:this_id]
		act = act_type.camelize.constantize
		this = act.find_by_id(params[:this_id])

		if !name_is_valid?(user, act_type); raise Errors::FlowError.new(send("#{act_type}_path", act_id)); end

		acts_administrating = user.send("#{act_type.pluralize}_administrating")
		act_to_administrate = act_type.camelize.constantize.find_by_id(act_id)

		if act_to_administrate.administrators.include? current_user
			# todo: check user has the right rank
				acts_administrating << act_to_administrate
			# activities
				act_to_administrate.create_activity key: "act_administration.create", owner: current_user, recipient: user
			# # #
		end

		@person = user
		@act =  act_to_administrate
		respond_to do |format|
			format.html { redirect_to act_to_administrate }
			format.js { render 'act_administrations/create', :locals => { this: this, person: user } }
		end
	end

	def destroy
		act_type = params[:this_type]
		user = User.find_by_id(params[:admin_id_deleted])
		act_id = params[:this_id]
		act = act_type.camelize.constantize
		this = act.find_by_id(params[:this_id])

		if !name_is_valid?(user, act_type); raise Errors::FlowError.new(send("#{act_type}_path", act_id)); end

		act_to_remove_admin_from = act_type.camelize.constantize.find_by_id(act_id)

		if current_user_can_delete_admin?(user, act_to_remove_admin_from)
			administrations = []
			administrations = user.act_administrations.where(act_type: act_type.camelize , act_id: act_id)
			administrations.each do |a|
				a.destroy
			end unless administrations == []
		end
		# activities
			act_to_remove_admin_from.create_activity key: "act_administration.destroy", owner: current_user, recipient: user
		# # #
		respond_to do |format|
			format.html { redirect_to act_to_remove_admin_from }
			format.js { render 'act_administrations/destroy', :locals => { this: this, person: user } }
		end
	end

	private

		# checks if offerign name is valid for user
		# note: this function is controller specific
		def name_is_valid?(user, this)
			user.respond_to? "#{this.pluralize}_administrating" and this_is_act?(this)
		end

end