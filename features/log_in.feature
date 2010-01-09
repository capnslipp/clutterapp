Feature: Log In
	In order to use ClutterApp
	As a user
	I want to be able to log in
	
	Scenario: User logs in successfully
		Given I am "a_user"
		When I log in
			Then I should see "my signed-in status" with "my username"
			Then I should be logged in
