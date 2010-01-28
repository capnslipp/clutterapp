require 'spec_helper'

describe PilesController do
  include PilesHelper
  dataset :piles
  
  
  def bypass_authentication
    PilesController.any_instance.stubs :logged_in? => true, :current_user => users(:a_user)
  end
  
  before(:each) do
    bypass_authentication
  end
  
  after(:each) do
    flash.now[:error].should be_nil
    flash.now[:warning].should be_nil
  end
  
  
  describe "GET actions" do
    
    after(:each) do
      response.should be_success
    end
    
    
    it "should get new" do
      get :new,
        :user_id => users(:a_user).to_param
    end
    
    
    it "should get edit" do
      get :edit,
        :user_id => users(:a_user).to_param,
        :id => users(:a_user).default_pile.to_param
    end
    
    
    it "should show pile" do
      get :show,
        :user_id => users(:a_user).to_param,
        :id => users(:a_user).default_pile.to_param
    end
    
  end
  
  
  describe "POST/PUT/DELETE actions" do
    
    after(:each) do
      response.should be_redirect
    end
    
    
    it "should create pile" do
      assert_difference 'Pile.count', +1 do
        post :create,
          :user_id => users(:a_user).to_param,
          :pile => {
            :name => 'Test Pile PCT 1'
          }
        
        assigns[:pile].should be_valid
        response.should_not redirect_to(:action => 'new')
      end
    end
    
    
    it "should update pile" do
      put :update,
        :user_id => users(:a_user).to_param,
        :id => users(:a_user).default_pile.to_param,
        :pile => {}
      
      assigns[:pile].should be_valid
      response.should_not redirect_to(:action => 'edit')
    end
    
    
    it "should destroy pile" do
      assert_difference 'Pile.count', -1 do
        delete :destroy,
          :user_id => users(:a_user).to_param,
          :id => users(:a_user).default_pile.to_param
      end
    end
    
  end
  
end
