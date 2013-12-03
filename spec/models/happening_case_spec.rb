require 'spec_helper'

describe HappeningCase do

	it "has a valid factory" do
		FactoryGirl.create(:happening_case).should be_valid
	end

	let(:account) { FactoryGirl.create(:account_with_user) }	
	let(:user) {account.user}
	let(:event) { FactoryGirl.create(:event) }
	let(:happening_case) { event.happening_case }	

	subject { happening_case }

# --- respond_to
	respond_array = []

		# attr_accessible
			respond_array += [:date_and_time, 
				:duration_type, 
				:happening_id, 
  				:happening_type, 
  				:time_from, 
  				:time_to, 
  				:title]

		# associations
			respond_array += [:happening]	

	respond_array.each do |message|
		it { should respond_to(message)}
	end
# ---

	describe "when date_and_time is empty" do
		before { happening_case.date_and_time = nil }
	    it { should_not be_valid }
	end

	describe "when duration_type is empty" do
		before { happening_case.duration_type = nil }
	    it { should_not be_valid }
	end

end
