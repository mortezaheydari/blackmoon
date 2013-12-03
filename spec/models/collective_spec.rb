require 'spec_helper'

describe Collective do

	it "has a valid factory" do
		owner = FactoryGirl.create(:venue)
		FactoryGirl.create(:collective, owner: owner).should be_valid
	end

	let(:owner) { FactoryGirl.create(:venue) }
	let(:collective) { FactoryGirl.create(:collective, owner: owner) }
	subject { collective }

# --- respond_to
	respond_array = []

		# attr_accessible
			respond_array += [:title]

		# associations
			respond_array += [:owner, :offering_sessions]

	respond_array.each do |message|
		it { should respond_to(message)}
	end
# ---

end
