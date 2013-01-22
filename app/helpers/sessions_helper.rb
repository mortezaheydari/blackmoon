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

		def date_helper_to_str(date)
			"#{date[:year]}-#{date[:month]}-#{date[:day]}"
		end  

end