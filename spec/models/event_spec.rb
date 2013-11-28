require 'spec_helper'

describe Event do

	let(:account) { FactoryGirl.create(:account_with_user) }	
	let(:user) {account.user}
	let(:event) { FactoryGirl.create(:event) }

	subject { event }

# --- respond_to
	respond_array = []

		# attr_accessible
			respond_array += [:category, 
				:descreption, 
  				:title, 
  				:tournament_id, 
  				:fee, 
  				:fee_type, 
  				:sport, 
  				:number_of_attendings, 
  				:team_participation, 
  				:open_join]

		# Joinable aspect
			respond_array += [:inviteds,
				:join_requests_received, 
				:individual_participators, 
				:team_participators, 
				:joineds,
				:happening_case]

		# Offerable aspect
			respond_array += [:location, :creator, :administrators]

		# Albumable aspect
			respond_array += [:album, :logo]				

	respond_array.each do |message|
		it { should respond_to(message)}
	end
# ---

end
