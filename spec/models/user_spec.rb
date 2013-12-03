require 'spec_helper'

describe User do

	it "has a valid factory" do
		account = FactoryGirl.create(:account_with_user)
		account.user.should be_valid
		FactoryGirl.create(:user).should be_valid
	end

	let(:account) { FactoryGirl.create(:account_with_user) }
	let(:user) { account.user }

	subject { user }


# --- respond_to
	respond_array = []

		# attr_accessible
			respond_array += [:name]

		# associations
			respond_array += [:profile,	:account]
			
		# methods
			respond_array += [:following?,
				:follow!,
				:unfollow!,
				:title]

		# Albumable aspect
			respond_array += [:album, :logo]
    
		# MoonActor aspect
			respond_array += [:invitations_sent,
				:invitations_received,
				:join_requests_sent,
				:offerings_participating,
				:games_participating,
				:events_participating,
				:offering_sessions_participating,
				:offerings_administrating,
				:games_administrating,
				:events_administrating,
				:offerings_created,
				:games_created,
				:events_created,
				:teams_created,
				:teams_administrating,
				:teams_membership]

	respond_array.each do |respond_object|
		it { should respond_to(respond_object)}
	end
# ---



  describe "when name is not present" do
    before {user.name = " "}
    it { should_not be_valid}
  end

  describe "when name is too long" do
    before {user.name = "a" * 51}
    it { should_not be_valid }
  end

	describe "with username already taken" do
		before do
			user_with_same_name = user.dup
			user_with_same_name.save.should_not be_valid		  
		end

	end

end
