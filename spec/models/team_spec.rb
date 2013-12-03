require 'spec_helper'

describe Team do

	let(:account) { FactoryGirl.create(:account_with_user) }	
	let(:user) {account.user}
	let(:team) { FactoryGirl.create(:team) }

	subject { team }

# --- respond_to
	respond_array = []

		# attr_accessible
			respond_array += [:descreption, 
				:sport, 
				:number_of_attendings, 
				:title, 
				:category, 
				:open_join]
		  # Offerable aspect
			respond_array += [:creator, :administrators]

		  # Joinable aspect
			respond_array += [:inviteds, 
				:join_requests_received, 
				:individual_participators,
				:members, 
				:joineds]

		# Albumable aspect
			respond_array += [:album, :logo]

		# MoonActor aspect
			respond_array += [:invitations_sent, 
				:invitations_received, 
				:join_requests_sent, 
				:offerings_participating, 
				:games_participating, 
				:events_participating]

	respond_array.each do |message|
		it { should respond_to(message)}
	end
# ---
end
