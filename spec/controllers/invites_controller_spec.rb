require 'spec_helper'

describe InvitesController do
  include InvitesHelper
  integrate_views
  
  
  it "should new" do
    get :new
    assert_template 'new'
  end
  
  
  describe "create" do
    
    it "should not when invalid" do
      post :create
      response.should redirect_to(root_url)
    end
    
    
    it "should not when blank invite email" do
      post :create, { :invite => {:recipient_email => ''} }
      response.should redirect_to(root_url)
    end
    
    
    it "should not when nil invite email" do
      post :create, { :invite => {:recipient_email => nil} }
      response.should redirect_to(root_url)
    end
    
    
    it "should when valid" do
      post :create, { :invite => {:recipient_email => 'InvitesControllerTest@example.com'} }
      response.should redirect_to(root_url)
    end
    
  end
  
  
end
