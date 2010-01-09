Feature: Pile List
	In order access Piles
	As a user
	I want to be able to see and click Piles (that I'm authorized for)
	
	Scenario Outline: User accesses dashboard
		Given I am "a_user"
		Given I am logged in
		When I go to my dashboard page
			Then I should see "<pile_name>"
		When I follow "<pile_name>"
			Then I should be on the Pile "<pile_name>" page
			Then I should be see the "<pile_name>" header
		
		Examples:
			| pile_name     |
			| a_user's Pile |
			| A Pile        |
			| A Better Pile |
