require 'spec_helper'
describe "Registration" do
	subject { page }

	before { visit new_account_registration }
	describe "with invalid information" do
		it "should not create an account" do
			expect { click_button "Sign up"}.not_to change(Account, :count)
		end
		it "should not create a user" do
			expect { click_button "Sign up"}.not_to change(User, :count)
		end		
	end


	
end