require 'spec_helper'

describe Account do
	before { @account = FactoryGirl.create(:account) }

  subject { @account }

  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }  
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }  
#  it { should respond_to(:remember_token) }  
	it { should respond_to(:user) }

#	describe "when password don't match" do
#		before { @account = }
#	end
	describe "profile" do
		#
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
