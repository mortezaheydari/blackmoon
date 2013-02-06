module EventsHelper

	def toggle_like_button(event, user)
		if user.flagged?(event, :like)
			link_to content_tag("div", "", class: "UnlikeButton"), like_event_path(event), remote: true
		else
                                link_to content_tag("div", "", class: "likeButton"), like_event_path(event), remote: true
		end
	end

            def toggle_like_card_button(event, user)
                if user.flagged?(event, :like)
                    link_to content_tag("div", "", class: "thumbedUp"), like_event_path(event), card_id: event.id
                else
                    ink_to content_tag("div", "", class: "thumbsUp"), like_event_path(event), card_id: event.id
                end
            end
end
