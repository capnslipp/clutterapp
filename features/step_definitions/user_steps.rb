Given /^I am "([^\"]*)"$/ do |username|
  @user = User.find_by_login(username)
  assert_not_nil @user
end

When /^I log in$/ do
  visit login_url
  fill_in 'user_session[login]', :with => @user.login
  fill_in 'user_session[password]', :with => 'secret' # @user.password
  submit_form 'Log in'
end

Then /^I should be signed in$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see a signed in status with my username$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I return next time$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should still be signed in$/ do
  pending # express the regexp above with the code you wish you had
end
