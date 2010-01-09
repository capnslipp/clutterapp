Feature: Pile List
	In order access Piles
	As a user
	I want to be able to see and click Piles (that I'm authorized for)
	
	Scenario: User accesses dashboard
		Given I am "a_user"
		Given I am logged in
		When I go to my dashboard page
			Then I should see "my piles"
		When I click each of "my piles"
			Then I should go to "that pile"
