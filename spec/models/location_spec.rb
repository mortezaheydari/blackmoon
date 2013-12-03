require 'spec_helper'

describe Location do

	it "has a valid factory" do
		event = FactoryGirl.create(:event)
		event.location.should be_valid
		FactoryGirl.create(:location).should be_valid
	end

	let(:account) { FactoryGirl.create(:account_with_user) }	
	let(:user) {account.user}
	let(:event) { FactoryGirl.create(:event) }
	let(:location) { event.location }	
	
	subject { location }

# --- respond_to
	respond_array = []

		# attr_accessible
			respond_array += [:city, 
				:custom_address, 
				:custom_address_use, 
				:gmap_use, 
				:latitude, 
				:longitude, 
				:owner_id, 
				:owner_type, 
				:title, 
				:gmaps]

		# associations
			respond_array += [:owner]
		# methods
			respond_array += [:gmaps4rails_address]

	respond_array.each do |message|
		it { should respond_to(message)}
	end
# ---

end
