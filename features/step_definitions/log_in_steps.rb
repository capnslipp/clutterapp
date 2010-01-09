
Given /^I am "([^\"]*)"$/ do |name|
  assert_not_nil @user = User.find_by_login(name) || User.find_by_name(name)
end


When /^I log in$/ do
  visit login_url
  fill_in 'user_session[login]', :with => @user.attributes['login'] # @user.login, if it worked
  fill_in 'user_session[password]', :with => 'secret' # @user.password, if it were possible
  submit_form 'new_user_session'
end


Then /^I should(?: still)? be logged in$/ do
  assert controller.send(:current_user?)
end


Then /^I should not be logged in$/ do
  assert !controller.send(:current_user?)
end


Then /^I should see "([^\"]*)" with "([^\"]*)"$/ do |thing, with|
  regexp = seeing_regexp(thing, with)
  if defined?(Spec::Rails::Matchers)
    response.should contain regexp
  else
    assert_contain regexp
  end
end


When /^I return next time$/ do
  pending # express the regexp above with the code you wish you had
end


Then /^I should still be signed in$/ do
  pending # express the regexp above with the code you wish you had
end
