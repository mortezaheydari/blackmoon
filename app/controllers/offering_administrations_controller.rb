class OfferingAdministrationsController < ApplicationController
	include SessionsHelper
	before_filter :authenticate_account!

	def create
		offering_type = params[:this_type]
		user = User.find_by_id(params[:admin_id_added])
		offering_id = params[:this_id]
		offering = offering_type.camelize.constantize
		this = offering.find_by_id(params[:this_id])

		if !name_is_valid?(user, offering_type); raise Errors::FlowError.new(send("#{offering_type}_path", offering_id), "Permission denied."); end

		offerings_administrating = user.send("#{offering_type.pluralize}_administrating")
		offering_to_administrate = offering_type.camelize.constantize.find_by_id(offering_id)

		unless offering_to_administrate; raise Errors::FlowError.new; end

		if offering_to_administrate.administrators.include? current_user
		# todo: check user has the right rank
			offerings_administrating << offering_to_administrate
			# activities
				offering_to_administrate.create_activity key: "offering_administration.create", owner: current_user, recipient: user
			# # #			
		else
			raise Errors::FlowError.new(send("#{offering_type}_path", offering_id), "Permission denied.")
		end

		respond_to do |format|
			format.html { redirect_to offering_to_administrate }
			format.js { render 'offering_administrations/create', :locals => { this: this, person: user } }
		end
	end

	def destroy
		offering_type = params[:this_type]
		user = User.find_by_id(params[:admin_id_deleted])
		offering_id = params[:this_id]
		offering = offering_type.camelize.constantize
		this = offering.find_by_id(params[:this_id])

		if !name_is_valid?(user, offering_type); raise Errors::FlowError.new(send("#{offering_type}_path", offering_id), "Permission denied."); end

		offering_to_remove_admin_from = offering_type.camelize.constantize.find_by_id(offering_id)

		unless offering_to_remove_admin_from; raise Errors::FlowError.new; end

		if current_user_can_delete_admin?(user, offering_to_remove_admin_from)
			administrations = []
			administrations = user.offering_administrations.where(offering_type: offering_type.camelize , offering_id: offering_id)
			administrations.each do |a|
				offering_to_remove_admin_from.create_activity key: "offering_administration.destroy", owner: current_user, recipient: user

				a.destroy
			end unless administrations == []
		else
			raise Errors::FlowError.new(send("#{offering_type}_path", offering_id), "Permission denied.")
		end
		# activities
			offering_to_remove_admin_from.create_activity key: "offering_administration.destroy", owner: current_user, recipient: user
		# # #
		respond_to do |format|
			format.html { redirect_to offering_to_remove_admin_from }
			format.js { render 'offering_administrations/destroy', :locals => { this: this, person: user } }
		end
	end

  private

	# checks if offerign name is valid for user
	# note: this function is controller specific
	def name_is_valid?(user, this)
		user.respond_to? "#{name}s_administrating" and (this_is_offering?(name) || this_is_multisession?(this))
	end

end
