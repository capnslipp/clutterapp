Feature: Log In
	In order to use ClutterApp
	As a user
	I want to be able to log in
	
	Scenario: User logs in successfully
		Given I am "a_user"
		When I log in
		Then I should be signed in
			And I should see "the signed-in status" with "my username"
		When I return next time
			Then I should still be signed in
