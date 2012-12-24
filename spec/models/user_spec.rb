require 'spec_helper'

describe User do
	let(:account) { FactoryGirl.create(:account) }

	before { @user = account.build_user(name:	"username") }

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:profile) }	
	it { should respond_to(:account) }
	its(:account) { should == account }

  describe "when name is not present" do
    before {@user.name = " "}
    it { should_not be_valid}
  end

  describe "when name is too long" do
    before {@user.name = "a" * 51}
    it { should_not be_valid }
  end

	describe "with username already taken" do
		before do
			user_with_same_name = @user.dup
			user_with_same_name.save		  
		end
		it { should_not be_valid }
	end

end
