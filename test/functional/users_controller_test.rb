require 'test_helper'

#require 'users_controller'
## Re-raise errors caught by the controller.
#class UsersController; def rescue_action(e) raise e end; end


class UsersControllerTest < ActionController::TestCase
  
  def test_should_allow_signup
    assert_difference 'User.count', +1 do
      create_user
      assert_success_or_redirect
    end
  end
  
  def test_should_require_signup_code_on_signup
    assert_no_difference 'User.count' do
      create_user(:signup_code => '')
      assert_success_or_redirect
    end
  end
  
  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => '')
      assert assigns(:user).errors.on(:login)
      assert_success_or_redirect
    end
  end
  
  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => '')
      assert assigns(:user).errors.on(:password)
      assert_success_or_redirect
    end
  end
  
  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => '')
      assert assigns(:user).errors.on(:password_confirmation)
      assert_success_or_redirect
    end
  end
  
  def test_should_require_email_on_signup
    assert_no_difference 'User.count' do
      create_user(:email => '')
      assert assigns(:user).errors.on(:email)
      assert_success_or_redirect
    end
  end
  
  
protected
  
  def create_user(options = {})
    uid = User.last.id + 1
    
    post :create,
      :signup_code => options.delete(:signup_code) || UsersController.send(:current_signup_code),
      :user => {
        :login => "test_user_#{uid}",
        :email => "test_#{uid}@example.com",
        :password => 'secret',
        :password_confirmation => 'secret',
      }.merge(options)
  end
  
  def assert_success_or_redirect
    assert @response.send(:success?) || @response.send(:redirect?)
  end
  
end
