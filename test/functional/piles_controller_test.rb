require 'test_helper'

class PilesControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:piles)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should create pile" do
    assert_difference('Pile.count') do
      post :create, :pile => { }
    end
    
    assert_redirected_to pile_path(assigns(:pile))
  end
  
  test "should show pile" do
    get :show, :id => piles(:one).to_param
    assert_response :success
  end
  
  test "should get edit" do
    get :edit, :id => piles(:one).to_param
    assert_response :success
  end
  
  test "should update pile" do
    put :update, :id => piles(:one).to_param, :pile => { }
    assert_redirected_to pile_path(assigns(:pile))
  end
  
  test "should destroy pile" do
    assert_difference('Pile.count', -1) do
      delete :destroy, :id => piles(:one).to_param
    end
    
    assert_redirected_to piles_path
  end
  
end
