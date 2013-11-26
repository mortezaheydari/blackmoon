Feature: Basic and public
	As a public user 
	I want to surfe public pages

Scenario: Public User should see Home page
    Given I am on the home page
    Then I should see "New to GOBOOM? JOIN NOW"
    And I should see "Follow & Find"
    And I should see "Recent Activities"

Scenario: Home page should have menue items
    Given I am on the home page
    Then I should see "Events"
    And I should see "Games"
    And I should see "Classes"
    And I should see "Teams"
    And I should see "Sign In"    
    # And I should see "Venues"

Scenario: Events page
    Given I am on the home page
    And I follow "Events"
    Then I should see "Activity"

Scenario: Games page
    Given I am on the home page
    And I follow "Games"
    Then I should see "Activity"

Scenario: Sign in
    Given I am on the home page
    And I follow "Sign In"
    Then I should see "Email"
    And I should see "Password"
    And I should see "Forgot your password?"
    And I should see "Sign Up"
    When I follow "Sign Up" 
    Then I should see "Name"
    And I should see "Email"
    And I should see "Password"
    And I should see "Password confirmation"
    And I should see "Sign In"    

Scenario: Sign up
    Given I am on the home page
    And I follow "Sign In"
    Then I should see "Name"
    And I should see "Email"
    And I should see "Password"
    And I should see "Password confirmation"
    And I should see "Sign In"
    When I follow "Sign In"
    Then I should see "Email"
    And I should see "Password"
    And I should see "Forgot your password?"    