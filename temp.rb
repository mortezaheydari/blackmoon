    link_to "join", controller: :offering_individual_participations_controller, action: :create, offering_type: "event", offering_id: "offering_id", joining_user: current_user

    link_to "leave", controller: :offering_individual_participations_controller, action: :destroy, offering_type: "event", offering_id: "offering_id", leaving_user: current_user