module SessionsHelper

	private
		def current_user=(user)
			@current_user = user
		end

		def current_user
			@current_user ||= current_account.user
		end

  	 def current_user?(user)
		user == current_user
	 end

	  def user_is_admin?(this, user=current_user)
	    this.administrators.include?(user)
	  end

	  def user_created_this?(this, user=current_user)
	    this.creator == user
	  end

	  def user_is_participating?(this, user=current_user)
	    this.individual_participators.include?(user)
	  end

		def date_helper_to_str(date)
			"#{date[:year]}-#{date[:month]}-#{date[:day]}"
		end

            def current_user_can_delete_admin?(admin, this)
                # todo: add superadmin
                user_is_admin?(this) && (user_created_this?(this) or current_user?(admin)) && this.administrators.count > 1
            end

end