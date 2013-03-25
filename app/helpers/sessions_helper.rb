module SessionsHelper


	def current_user=(user)
		@current_user = user
	end

	def current_user
                          if account_signed_in?
		@current_user ||= current_account.user
                          else
                              @current_user ||= User.new
                          end
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

	def toggle_like_card_button(this, user, options = {})
		class_name = this.class.to_s.downcase
                      style_id = ""
                      style_id = options[:style_id] unless options[:style_id].nil?

		if user.flagged?(this, :like)
			thumbs ="thumbedUp"
		else
			thumbs ="thumbsUp"
		end


                      link_to content_tag("div", "", class: thumbs, id: "thumbs#{style_id + "like"}"), send("like_cards_#{class_name}_path", this, id: this.id, style_id: style_id, class_name: options[:class_name]), remote: true
	end
            def k_lower(this)
                this.class.to_s.downcase
            end

            def k_lower_p(this)
                this.class.to_s.downcase.pluralize
            end

            def this_is_offering?(this)
                if this.class.to_s == "String"
                    ["event", "game", "class"].include?(this)
                else
                    ["event", "game", "class"].include?(k_lower(this))
                end
            end

            def this_is_act?(this)
                if this.class.to_s == "String"
                    ["team", "sponsor", "organization"].include?(this)
                else
                    ["team", "sponsor", "organization"].include?(k_lower(this))
                end
            end
        # def class_name(this)
        #     this.class.to_s.downcase
        # end


end