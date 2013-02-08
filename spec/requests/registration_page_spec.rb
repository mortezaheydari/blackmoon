require 'spec_helper'
describe "Registration" do
	subject { page }

	before { visit new_account_registration_path }
	describe "with invalid information" do
		it "should not create an account" do
			expect { click_button "Sign up"}.not_to change(Account, :count)
		end
		it "should not create a user" do
			expect { click_button "Sign up"}.not_to change(User, :count)
		end	
		describe "error messages" do
  		before { click_button "Sign up" }
  		it { should have_content('error') }
  	end	
	end

	describe "with valid information" do
		before do
		  fill_in 'account_user_attributes_name', 		with: "Example User"
		  fill_in 'account_email', 		with: "user@example.com"
		  fill_in 'account_password',	with: "password"
		  fill_in 'account_password_confirmation',	with: "password"	  
		end
		it "should create an account" do
			expect { click_button "Sign up"}.to change(Account, :count)
		end
		it "should create a user" do
			expect { click_button "Sign up"}.to change(User, :count)
		end	
		it "should create a profile" do
			expect { click_button "Sign up"}.to change(Profile, :count)
		end	
	end
end