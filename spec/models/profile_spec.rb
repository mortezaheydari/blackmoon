require 'spec_helper'

describe Profile do
	
	let(:user) { FactoryGirl.create(:user) }
	before { @profile = user.build_profile(first_name: "Mr a") }


	subject { @profile }

	it { should respond_to(:first_name) }
	it { should respond_to(:user) }
	its(:user) { should == user }
end
