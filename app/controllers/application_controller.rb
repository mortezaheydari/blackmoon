class ApplicationController < ActionController::Base
  include SessionsHelper
	include PublicActivity::StoreController

  protect_from_forgery

  private

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
		double_check(root_path, 'permission error: name is not valid!') {
			name_is_valid?(user, name) }
	end

	# find and assign, dose it without administration check,
	# whereas this_if_reachable might also consider (this.administrators.include? current_user).

	def find_and_assign this_type, this_id

		if ["user", "team", "event", "game", "venue", "offering_session"].include? this_type.underscore and this_id
			a = root_path
			a = @redirect_object unless @redirect_object.nil?

		redirect_to(a, notice: 'error') and return unless this = this_type.camelize.constantize.find_by_id(this_id)

			this
		end
	end

	def this_if_reachable(this_type, this_id)
		name_is_valid?(this_type) unless this_type == "Collective"
		this = this_type.constantize.find(this_id)
		double_check { this }
                        this
	end

	def owner_if_reachable(owner_type, owner_id)
		owner = this_if_reachable(owner_type, owner_id)
		if owner_type == "Collective"
			double_check { owner.owner.administrators.include? current_user }
		else
			double_check { owner.administrators.include? current_user }
		end
		owner
	end

	# My Bloodthirsty double_check method, version-20131023
	def double_check(link=root_path, msg='there was an error with your request', &b)
		link == @redirect_object unless @redirect_object.nil?
		unless b.call
			return redirect_to(link, alert: msg)
		end
	end
	# -ended




end
