require 'test_helper'


class PilesControllerTest < ActionController::TestCase
  dataset :piles
  
  
  #test "should get index" do
  #  bypass_authentication
  #  
  #  get :index, :user_id => users(:a_user)
  #  assert_response :success
  #  assert_not_nil assigns(:piles)
  #end
  
  
  test "should get new" do
    bypass_authentication
    
    get :new,
      :user_id => users(:a_user)
    
    assert_success_or_redirect
  end
  
  
  test "should create pile" do
    bypass_authentication
    
    assert_difference 'Pile.count', +1 do
      post :create,
        :user_id => users(:a_user),
        :pile => {
          :name => 'Test Pile PCT 1'
        }
      
      #assert assigns(:pile).valid?
      assert_response :redirect
      assert_redirected_to :action => 'new'
    end
  end
  
  
  test "should show pile" do
    bypass_authentication
    
    get :show,
      :user_id => users(:a_user),
      :id => piles(:a_better_pile).to_param
    
    assert_success_or_redirect
  end
  
  
  test "should get edit" do
    bypass_authentication
    
    get :edit,
      :user_id => users(:a_user),
      :id => piles(:a_better_pile).to_param
    
    assert_success_or_redirect
  end
  
  
  test "should update pile" do
    bypass_authentication
    
    put :update,
      :user_id => users(:a_user),
      :id => piles(:a_better_pile).to_param,
      :pile => {}
    
    assert_success_or_redirect
  end
  
  
  test "should destroy pile" do
    bypass_authentication
    
    assert_difference('Pile.count', -1) do
      delete :destroy,
        :user_id => users(:a_user),
        :id => piles(:a_better_pile).to_param
      
      assert_success_or_redirect
    end
  end
  
  
protected
  
  def bypass_authentication
    PilesController.any_instance.stubs :logged_in? => true, :current_user => users(:a_user)
  end
  
  def assert_success_or_redirect
    assert @response.send(:success?) || @response.send(:redirect?)
  end
  
  def current_path
    URI.parse(current_url).select(:path, :query).compact.join('?')
  end
  
end
