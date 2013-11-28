require 'spec_helper'

describe Logo do

	let(:event) { FactoryGirl.create(:event) }	
	let(:logo) { event.logo }
	
	subject { logo }

# --- respond_to
	respond_array = []

		# attr_accessible
			respond_array += [:photo_id]

		# associations
			respond_array += [:photo, :owner]	

		# methods
			respond_array += [:uses]

	respond_array.each do |message|
		it { should respond_to(message)}
	end
# ---	
end
