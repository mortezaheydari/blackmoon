module OfferingSearchable
  attr_accessor:updated_at

	case self.class.to_s

	when "Event", "Game"
	    searchable do
	        text :title, :boost => 5
	        text :description
	        # string :fee_type
	        string :sport
	        boolean :team_participation
	        date :updated_at
	    end
	when "Venue", "GroupTraining" "PersonalTrainer"
		searchable do
			text :title, :boost => 5
			text :descreption
			date :updated_at
		end
	end
	when "Team"
		searchable do
			text :title, :boost => 5
			text :descreption
			# string :fee_type
			string :sport
			date :updated_at
		end
	end
end