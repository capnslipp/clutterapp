require 'test_helper'

class InvitesControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    post :create
    assert_redirected_to root_url
  end
  
  def test_create_blank_invite_email
    post :create, { :invite => {:recipient_email => ''} }
    assert_redirected_to root_url
  end
  
  def test_create_nil_invite_email
    post :create, { :invite => {:recipient_email => nil} }
    assert_redirected_to root_url
  end
  
  def test_create_valid
    post :create, { :invite => {:recipient_email => 'InvitesControllerTest@example.com'} }
    assert_redirected_to root_url
  end
  
end
