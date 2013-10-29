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

	    def name_is_valid?(name)
	      ["event","class","game", "user", "team", "venue"].include? name.downcase
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

	    def find_and_assign this_type, this_id

	        if ["user", "team", "event", "game", "venue"].include? this_type.downcase and this_id
	            a = root_path
	            a = @redirect_object unless @redirect_object.nil?
	            redirect_to(a, notice: 'error') and return unless this = this_type.camelize.constantize.find_by_id(this_id)
	            this
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
