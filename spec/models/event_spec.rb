require 'spec_helper'

describe Event do

	let(:account) { FactoryGirl.create(:account_with_user) }	
	let(:user) {account.user}
	let(:event) { FactoryGirl.create(:event) }

	subject { event }

# --- respond_to
	respond_array = []

		# attr_accessible
			respond_array += [:descreption, :title, :location]

		# MultiSessionJoinable aspect
			respond_array += [:happening_case, 
				:joineds, 
				:join_requests_received, 
				:individual_participators, 
				:team_participators, 
				:invitations]

		# Offerable aspect
			respond_array += [:location, :creator, :administrators]

		# Albumable aspect
			respond_array += [:album, :logo]				

	respond_array.each do |message|
		it { should respond_to(message)}
	end
# ---

end
