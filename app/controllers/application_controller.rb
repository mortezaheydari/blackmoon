class ApplicationController < ActionController::Base
  include SessionsHelper
	include PublicActivity::StoreController

  protect_from_forgery

  private

	# double check methodology that monitors an action and terminates the application upon failure.
	# including
	# - validating passed name
	# - finding and assigning object based on that name
	# - creating redirect objecet if required
	# - performing doublecheck, redirecting to redirect_object upon failure
	# starting:

=begin
	def set_this_variable(name=@model_name, value=@this)
		instance_variable_set("@#{name.underscore}", @this)
	end

	def set_these_variable(name=@model_name, value=@these)
		instance_variable_set("@#{name.underscore}", @these)
	end

	def set_this_class(name=@model_name)
		name.constantize
	end
=end

	def name_is_valid?(name)
	  ["event","class","game", "user", "team", "venue"].include? name.underscore
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
		@owner = this_if_reachable(owner_type, owner_id)
		if owner_type == "Collective"
			double_check { @owner.owner.administrators.include? current_user }
		else
			double_check { @owner.administrators.include? current_user }
		end
		@owner
	end

	def build_owner

	end

	# def double_check(&b)
	#     #redirect_to @owner, notice: 'error' and return unless b.call == true
	#     a = root_path
	#     a = @redirect_object unless @redirect_object.nil?
	#     redirect_to(a, notice: 'error') and return unless b.call == true
	# end

	# My Bloodthirsty double_check method, version-20131023
	def double_check(link=root_path, msg='there was an error with your request', &b)
		link == @redirect_object unless @redirect_object.nil?
		redirect_to(link, alert: msg) and return unless b.call
	end

	def double_check_name_is_valid(user, name)
		double_check(root_path, 'permission error: name is not valid!') {
			name_is_valid?(user, name) }
	end


	def unless_photo_exists(&b)
		if @photo_exists
			@photo = Photo.find_by_id(params[:photo_id])
		else
			b.call
		end
	end

	def redirect_object
		if params[:redirect_object]
			@redirect_object = params[:redirect_object]
		else
			return_object_id   = params[:return_object_id]
			return_object_type = params[:return_object_type]
			@redirect_object   = find_and_assign return_object_type, return_object_id
		end
		@redirect_object = root_path if @redirect_object.nil?
	end

	# -ended
end
