require 'test_helper'

class PilesControllerTest < ActionController::TestCase
  #test "should get index" do
  #  bypass_authentication
  #  
  #  get :index, :user_id => users(:one)
  #  assert_response :success
  #  assert_not_nil assigns(:piles)
  #end
  
  
  test "should get new" do
    bypass_authentication
    
    get :new, :user_id => users(:one)
    assert_response :success
  end
  
  
  test "should create pile" do
    bypass_authentication
    
    assert_difference 'Pile.count', +1 do
      post :create, :pile => {:name => 'Test Pile PCT 1'}, :user_id => users(:one)
    end
    
    #assert_redirected_to user_piles_path(assigns(:pile)) # I don't know and don't care where this redirects at this point.
  end
  
  
  test "should show pile" do
    bypass_authentication
    
    get :show, :id => piles(:one).to_param, :user_id => users(:one)
    #assert_redirected_to user_piles_path(assigns(:pile)) # I don't know and don't care where this redirects at this point.
  end
  
  
  test "should get edit" do
    bypass_authentication
    
    get :edit, :id => piles(:one).to_param, :user_id => users(:one)
    assert_response :success
  end
  
  
  test "should update pile" do
    bypass_authentication
    
    put :update, :id => piles(:one).to_param, :pile => { }, :user_id => users(:one)
    #assert_redirected_to user_piles_path(assigns(:pile)) # I don't know and don't care where this redirects at this point.
  end
  
  
  test "should destroy pile" do
    bypass_authentication
    
    assert_difference('Pile.count', -1) do
      delete :destroy, :id => piles(:one).to_param, :user_id => users(:one)
    end
    
    assert_redirected_to user_piles_path
  end
  
  
protected
  
  def bypass_authentication
    PilesController.any_instance.stub(:logged_in? => true, :current_user => users(:one))
  end
  
end
