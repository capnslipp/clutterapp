require 'spec_helper'

describe UsersController do
  include UsersHelper
  dataset :users
  integrate_views
  
  
  def post_create_user(options = {})
    unique_id = User.last.id + 1
    
    post :create,
      :signup_code => options.delete(:signup_code) || UsersController.send(:current_signup_code),
      :user => {
        :login => "test_user_#{unique_id}",
        :email => "test_#{unique_id}@example.com",
        :password => 'secret',
        :password_confirmation => 'secret',
      }.merge(options)
  end
  
  
  it "should allow signup" do
    assert_difference 'User.count', +1 do
      post_create_user
      response.should be_redirect
    end
  end
  
  
  it "should require signup code on signup" do
    assert_no_difference 'User.count' do
      post_create_user(:signup_code => '')
      response.should be_success
    end
  end
  
  
  it "should require login on signup" do
    assert_no_difference 'User.count' do
      post_create_user(:login => '')
      assert assigns(:user).errors.on(:login)
      response.should be_success
    end
  end
  
  
  it "should require password on signup" do
    assert_no_difference 'User.count' do
      post_create_user(:password => '')
      assert assigns(:user).errors.on(:password)
      response.should be_success
    end
  end
  
  
  it "should require password confirmation on signup" do
    assert_no_difference 'User.count' do
      post_create_user(:password_confirmation => '')
      assert assigns(:user).errors.on(:password_confirmation)
      response.should be_success
    end
  end
  
  
  it "should require email on signup" do
    assert_no_difference 'User.count' do
      post_create_user(:email => '')
      assert assigns(:user).errors.on(:email)
      response.should be_success
    end
  end
  
  
end
