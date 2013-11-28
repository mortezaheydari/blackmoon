require 'spec_helper'

describe Album do

	let(:account) { FactoryGirl.create(:account) }
	before { 
		@user = account.build_user(name:	"username")
		@album = @user.build_album
	 }

	subject { @album }


# --- respond_to
	respond_array = []

		# attr_accessible
			respond_array += [:title]

		# associations
			respond_array += [:owner, :album_photos]

	respond_array.each do |respond_object|
		it { should respond_to(respond_object)}
	end
end
