module EventsHelper
    def toggle_like_button(event, user)
        if user.flagged?(event, :like)
            link_to "Unlike", like_event_path(event)
        else
            link_to "like", like_event_path(event)
        end
    end
end
