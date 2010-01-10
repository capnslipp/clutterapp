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
  
  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_success_or_redirect
    end
  end
  
  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_success_or_redirect
    end
  end
  
  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_success_or_redirect
    end
  end
  
  def test_should_require_email_on_signup
    assert_no_difference 'User.count' do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_success_or_redirect
    end
  end
  
  
protected
  
  def create_user(options = {})
    invite = Invite.new(:recipient_email => 'quire@example.com')
    invite.save_with_validation(true)
    
    post :create, :user => {
      :login => 'quire_',
      :email => 'quire@example.com',
      :password => 'quire69',
      :password_confirmation => 'quire69',
      :invite_token => invite.token
    }.merge(options)
  end
  
  def assert_success_or_redirect
    assert @response.send(:success?) || @response.send(:redirect?)
  end
  
end
