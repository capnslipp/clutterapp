Feature: Pile List
	In order access Piles
	As a user
	I want to be able to see and click Piles (that I'm authorized for)
	
	Scenario Outline: User accesses dashboard
		Given I am "a_user"
		Given I am logged in
		When I go to my dashboard page
			Then I should see a [Pile:<pile>:name] link
		When I follow the [Pile:<pile>:name] link
			Then I should be at [Pile:<pile>:path]
			Then I should be see the [Pile:<pile>:name] header
		
		Examples:
			| pile                 |
			| a_users_default_pile |
			| a_pile               |
			| a_better_pile        |
