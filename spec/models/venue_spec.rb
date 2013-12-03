require 'spec_helper'

describe Venue do

	it "has a valid factory" do
		FactoryGirl.create(:venue).should be_valid
	end

	let(:account) { FactoryGirl.create(:account_with_user) }	
	let(:user) {account.user}
	let(:venue) { FactoryGirl.create(:venue) }

	subject { venue }
	
# --- respond_to
	respond_array = []

		# attr_accessible
			respond_array += [:descreption, :title, :location]

		# MultiSessionJoinable aspect
			respond_array += [:offering_sessions, 
			  	:happening_cases, 
			    :joineds, 
			    :join_requests_received, 
			    :individual_participators, 
			    :invitations, 
			    :collectives]

		# Offerable aspect
			respond_array += [:location, :creator, :administrators]

		# Albumable aspect
			respond_array += [:album, :logo]				

	respond_array.each do |message|
		it { should respond_to(message)}
	end
# ---
end
