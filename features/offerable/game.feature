Feature: Offerable entities
	As a user, 
	I want to provide offerings and be provided with them
	

Background:
    Given I am on the home page
    And I fill in "account_user_attributes_name" within "form#new_account" with "Mr second"
    And I fill in "account_email" within "form#new_account" with "second@example.com"
    And I fill in "account_password" within "form#new_account" with "123456@ab"
    And I fill in "account_password_confirmation" within "form#new_account" with "123456@ab"
    And I press "Register me"
    And I follow "Sign out"    

    Scenario: Create a bad game

    	Given I visit "/games/new"
        Then I should see "You need to sign in or sign up before continuing."

        When I fill in "account_email" with "second@example.com"
        And I fill in "account_password" with "123456@ab"
        And I press "Sign in"
        Then I should not see "Sign In"
        And I should see "Signed in successfully"
        And I should see "Create New Game"        
        # And I inspect page

    	And I click on "Create the game"
    	Then I should see "Create New Game"
        And I should see "there has been a problem with data entry." 
        
    Scenario: Create a good game

        Given I visit "/games/new"
        Then I should see "You need to sign in or sign up before continuing."

        When I fill in "account_email" with "second@example.com"
        And I fill in "account_password" with "123456@ab"
        And I press "Sign in"
        Then I should not see "Sign In"
        And I should see "Signed in successfully"
        And I should see "Create New Game"        
        # And I inspect page

        When I fill in "game_title" with "First Game"
        And I fill in "game_description" with "description"
        And I fill in "happening_case_date_and_time" with "2014-12-01"
        And I click on "Create the game"
        Then I should see "First Game"
