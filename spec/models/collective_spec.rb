require 'spec_helper'

describe Collective do
	
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
