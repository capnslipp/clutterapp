
=begin
“Given” defs
=end

Given /^I am "([^\"]*)"$/ do |name|
  @user = User.find_by_login(name) || User.find_by_name(name)
  assert_not_nil @user
end




=begin
“When” defs
=end

When /^I log in$/ do
  visit login_url
  fill_in 'user_session[login]', :with => @user.attributes['login'] # @user.login, if it worked
  fill_in 'user_session[password]', :with => 'secret' # @user.password, if it were possible
  submit_form 'new_user_session'
end




=begin
“Then” defs
=end

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
