require 'spec_helper'

describe PilesController do
  include PilesHelper
  dataset :piles
  
  
  def bypass_authentication
    PilesController.any_instance.stubs :logged_in? => true, :current_user => users(:slippy_douglas)
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
    
    
    it "should show pile" do
      get :show,
        :user_id => users(:slippy_douglas).to_param,
        :id => users(:slippy_douglas).root_pile.to_param
    end
    
  end
  
  
end
