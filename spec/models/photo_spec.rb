require 'spec_helper'

describe Photo do

	it "has a valid factory" do
		FactoryGirl.create(:logo).should be_valid
		logo = FactoryGirl.create(:logo)
		logo.photo.should be_valid
		FactoryGirl.create(:photo).should be_valid
	end

	let(:logo) { FactoryGirl.create(:logo) }		
	let(:photo) { logo.photo }	
	
	subject { photo }


# --- respond_to
	respond_array = []

		# attr_accessible
			respond_array += [:title, :image]

		# associations
			respond_array += [:logos, :album_photos]	

		# methods
			respond_array += [:uses]

	respond_array.each do |message|
		it { should respond_to(message)}
	end
# ---	

end
