require 'spec_helper'

describe HappeningCase do

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

end
