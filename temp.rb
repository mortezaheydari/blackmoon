<%= link_to "<div class='joinButton'></div>", 
					offering_individual_participations_create_path(offering_type: "event", 
									offering_id: @event.id, joining_user: current_user), method: :post %>

<%= link_to "<div class='joinButton'></div>', 
					offering_individual_participations_create_path(offering_type: "event", 
									offering_id: @event.id, joining_user: current_user), method: :post %>