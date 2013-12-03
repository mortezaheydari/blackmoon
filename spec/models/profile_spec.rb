require 'spec_helper'

describe Profile do

	it "has a valid factory" do
		FactoryGirl.create(:user).should be_valid
		user = FactoryGirl.create(:user)
		user.profile.should be_valid
		FactoryGirl.create(:profile).should be_valid
	end
	
	let(:user) { FactoryGirl.create(:user) }
	let(:profile) { user.profile }	

	subject { profile }

# --- respond_to
	respond_array = []

		# attr_accessible
			respond_array += [:first_name,
				:last_name,
				:date_of_birth,
				:phone,
				:gender,
				:about,
				:user_id]

		# associations
			respond_array += [:user]

	respond_array.each do |respond_object|
		it { should respond_to(respond_object)}
	end
# ---

		
end
