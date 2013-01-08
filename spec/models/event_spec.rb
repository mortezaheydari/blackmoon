require 'spec_helper'

describe Event do

	let(:account) { FactoryGirl.create(:account_with_user) }	
	let(:user) {account.user}
	let(:event) { FactoryGirl.create(:event) }

	subject { event }

	it { should respond_to(:category) }
	it { should respond_to(:custom_address) }
	it { should respond_to(:date_and_time) }
	it { should respond_to(:descreption) }
	it { should respond_to(:location_type) }
	it { should respond_to(:title) }
	it { should respond_to(:tournament_id) }
	it { should respond_to(:creator)}
	it { should respond_to(:offering_creations)}	
end
