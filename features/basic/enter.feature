Feature: User entrance to website
	As a public user
	I want to enter the private section of website

Scenario: Register on home page
    Given I am on the home page
    When I fill in "account_user_attributes_name" within "form#new_account" with "Mr Example"
    And I fill in "account_email" within "form#new_account" with "sample@example.com"
    And I fill in "account_password" within "form#new_account" with "123456@ab"
    And I fill in "account_password_confirmation" within "form#new_account" with "123456@ab"
	And I press "Register me"
	Then I should not see "Sign In"
    Then I should see "Welcome! You have signed up successfully."
    And I should see "Create New"    

Scenario: Register on sign up page
    Given I visit "/accounts/sign_up"
    When I fill in "account_user_attributes_name" with "Mr Example"
    And I fill in "account_email" with "sample@example.com"
    And I fill in "account_password" with "123456@ab"
    And I fill in "account_password_confirmation" with "123456@ab"
	And I press "Sign Up"
	# And I inspect page
	Then I should not see "Sign In"
    And I should see "Welcome! You have signed up successfully."
    And I should see "Create New"

Scenario: Register on sign up popup
    Given I am on the home page
    When follow "Sign In"