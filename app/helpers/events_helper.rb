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
                    link_to content_tag("div", "", class: "thumbedUp"), like_cards_event_path(event), id: event.id, remote: true
                else
                    link_to content_tag("div", "", class: "thumbsUp"), like_cards_event_path(event), id: event.id, remote: true
                end
            end

            # def toggle_like_card_button(event, user)
            #     if user.flagged?(event, :like)
            #         @class = "thumbedUp"
            #     else
            #         @class = "thumbsUp"
            #     end
            #     form_for(event, remote: true, url: like_cards_event_path(event)) do |f|
            #         f.hidden_field :id
            #         f.submit "hello"
            #     end
            # end

end
