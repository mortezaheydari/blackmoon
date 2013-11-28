require 'spec_helper'

describe OfferingSession do
	let(:offering_session) { FactoryGirl.create(:offering_session) }

	subject { offering_session }


# --- respond_to
	respond_array = []

		# attr_accessible
			respond_array += [:descreption, 
				:number_of_attendings, 
				:title, 
				:collective_id]

		# associations
			respond_array += [:collective]

		# fake methods (to be removed)
			respond_array += [:collective_type, 
				:collective_title, 
				:repeat_duration, 
				:repeat_number, 
				:repeat_every]

		# Offerable aspect
			respond_array += [:location, 
				:creator, 
				:administrators]
			
		# Joinable aspect
			respond_array += [:inviteds, 
				:join_requests_received, 
				:individual_participators, 
				:team_participators, 
				:joineds, 
				:happening_case]


	respond_array.each do |message|
		it { should respond_to(message)}
	end
# ---
end
