require 'spec_helper'

describe Collective do
	
	let(:event) { FactoryGirl.create(:collective) }
	subject { event }

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
