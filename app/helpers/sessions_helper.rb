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

	def user_is_member?(this, user=current_user)
		this.members.include?(user)
	end


	def team_is_participating?(this, team)
		this.team_participators.include?(team)
	end

	def date_helper_to_str(date)
		"#{date[:year]}-#{date[:month]}-#{date[:day]}"
	end

	def current_user_can_delete_admin?(admin, this)
		# todo: add superadmin
		user_is_admin?(this) && (user_created_this?(this) or current_user?(admin)) && this.administrators.count > 1
	end


	def toggle_like_button(this, user)
		class_name = this.class.to_s.downcase
		if user.flagged?(this, :like)
			link_to content_tag("div", "", class: "UnlikeButton"), send("like_#{class_name}_path", this), remote: true
		else
			link_to content_tag("div", "", class: "likeButton"), send("like_#{class_name}_path", this), remote: true
		end
	end

	def toggle_like_card_button(this, user)
		class_name = this.class.to_s.downcase		
		if user.flagged?(this, :like)
			link_to content_tag("div", "", class: "thumbedUp"), send("like_cards_#{class_name}_path", this), id: this.id, remote: true
		else
			link_to content_tag("div", "", class: "thumbsUp"), send("like_cards_#{class_name}_path", this), id: this.id, remote: true
		end
	end

end