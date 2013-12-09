class ApplicationController < ActionController::Base
  include SessionsHelper
	include PublicActivity::StoreController

  protect_from_forgery



	# double check methodology that monitors an action and terminates the application upon failure.
	# including
	#
	# - validating passed name
	# - finding and assigning object based on that name
	# - creating redirect objecet if required
	# - performing doublecheck, redirecting to redirect_object upon failure
	# starting:

	def name_is_valid?(name)
	  ["event","class","game", "user", "team", "venue"].include? name.underscore
	end

	def double_check_name_is_valid(user, name)
		return false unless double_check(root_path, 'permission error: name is not valid!') {
			name_is_valid?(user, name) }
	end

	# find and assign, dose it without administration check,
	# whereas this_if_reachable might also consider (this.administrators.include? current_user).

	def find_and_assign this_type, this_id

		if ["user", "team", "event", "game", "venue", "offering_session"].include? this_type.underscore and this_id
			this_type.camelize.constantize.find_by_id(this_id)
		else
			nil
		end
	end

	def this_if_reachable(this_type, this_id)
		unless this_type == "Collective"
			return false unless double_check_name_is_valid?(this_type)
		end
		this = this_type.constantize.find(this_id)
		return false unless double_check { this }
        this
	end

	def owner_if_reachable(this_type, this_id)
		this = this_if_reachable(this_type, this_id)
		return false unless double_check { this }
		if this_type == "Collective"
			return false unless double_check { this.owner.administrators.include? current_user }
		else
			return false unless double_check { this.administrators.include? current_user }
		end
		this
	end

	# My Bloodthirsty double_check method, version-20131023
	def double_check(link=root_path, msg='there was an error with your request', &b)
		link == @redirect_object unless @redirect_object.nil?
		redirect_to(link, alert: msg) and return false unless b.call
	end
	# -ended




end
