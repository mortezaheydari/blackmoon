require 'spec_helper'

describe Account do

	it "has a valid factory" do
		FactoryGirl.create(:account).should be_valid
	end

	before { @account = FactoryGirl.create(:account_with_user) }

	subject { @account }

# --- respond_to
	respond_array = []

		# attr_accessible
			respond_array += [:email,
				:password_digest,
				:password,
				:password_confirmation]

		# associations
			respond_array += [:user]
			
		# methods
			respond_array += [:has_password?]

	respond_array.each do |message|
		it { should respond_to(message)}
	end
# ---


#	describe "when password don't match" do
#		before { @account = }
#	end
	describe "profile" do
		#
	end

	describe "destroying an account" do
		it "should change Account count" do
			expect { @account.destroy }.to change(Account, :count).by(-1)
		end
		it "should change User count" do
			expect { @account.destroy }.to change(User, :count).by(-1)
		end		
	end
	describe "traditional tests" do

	  describe "when email format is invalid" do
	    it "should be invalid" do
	      addresses = %w[account@foo,com account_at_foo.org example.account@foo.
	                     foo@bar_baz.com foo@bar+baz.com]
	      addresses.each do |invalid_address|
	        @account.email = invalid_address
	        @account.should_not be_valid
	      end
	    end  
	  end

	  describe "when email format is valid" do
	    it "should be valid" do
	      addresses = %w[account@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
	      addresses.each do |valid_address|
	        @account.email = valid_address
	        @account.should be_valid
	      end
	    end
	  end

	  describe "when email address is already taken" do
	    before do
				@account = Account.new(email: "test@blackmoon.com",
  								 password: "password", password_confirmation:	"password")
	      account_with_same_email = @account.dup
	      account_with_same_email.email = @account.email.upcase
	      account_with_same_email.save
	    end

	    it { should_not be_valid}
	  end

	  describe "when password is not present" do
	    before { @account.password = @account.password_confirmation = " " } 
	    it { should_not be_valid }
	  end

	  describe "when password doesn't match" do
	    before { @account.password_confirmation = "mismatch" }
	    it { should_not be_valid }
	  end

	  describe "with a password that is too short" do
	    before { @account.password = @account.password_confirmation = "a" * 5 }
	    it { should be_invalid }
	  end

	end

end
