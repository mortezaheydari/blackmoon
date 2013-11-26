Feature: User entrance to website
	As a public user
	I want to enter the private section of website

Background:
    Given I am on the home page
    And I fill in "account_user_attributes_name" within "form#new_account" with "Mr First"
    And I fill in "account_email" within "form#new_account" with "first@example.com"
    And I fill in "account_password" within "form#new_account" with "123456@ab"
    And I fill in "account_password_confirmation" within "form#new_account" with "123456@ab"
    And I press "Register me"
    And I follow "Sign out"
    And I am on the home page

    Scenario: Register on home page
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
    	Then I should not see "Sign In"
        And I should see "Welcome! You have signed up successfully."
        And I should see "Create New"

    Scenario: Register on sign up popup
        When follow "Sign Up"
        When I fill in "account_user_attributes_name" within "div#SignUp" with "Mr Example"
        And I fill in "account_email" within "div#SignUp" with "sample@example.com"
        And I fill in "account_password" within "div#SignUp" with "123456@ab"
        And I fill in "account_password_confirmation" within "div#SignUp" with "123456@ab"
        And I press "Sign Up" within "div#SignUp"
        Then I should not see "Sign In"
        And I should see "Welcome! You have signed up successfully."
        And I should see "Create New"

    Scenario: Sign_in on home page
        And I fill in "account_email" within "form#new_session" with "first@example.com"
        And I fill in "account_password" within "form#new_session" with "123456@ab"
        And I press "Sign In"
        Then I should not see "Sign In"
        Then I should see "Signed in successfully"
        And I should see "Create New"    

    Scenario: Sign_in on sign in page
        Given I visit "/accounts/sign_in"
        And I fill in "account_email" with "first@example.com"
        And I fill in "account_password" with "123456@ab"
        And I press "Sign in"
        Then I should not see "Sign In"
        And I should see "Signed in successfully"
        And I should see "Create New"

    Scenario: Sign_in on sign in popup
        When follow "Sign In"
        And I fill in "account_email" within "div#SignIn" with "first@example.com"
        And I fill in "account_password" within "div#SignIn" with "123456@ab"
        And I press "Sign In" within "div#SignIn"
        Then I should not see "Sign In"
        And I should see "Signed in successfully"
        And I should see "Create New"