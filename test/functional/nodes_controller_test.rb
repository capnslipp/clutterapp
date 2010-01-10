require 'test_helper'

class NodesControllerTest < ActionController::TestCase
  include NodesHelper
  dataset :nodes
  
  #test "should get index" do
  #  bypass_authentication
  #  
  #  get :index, :user_id => @joe_user.to_param
  #  assert_response :success
  #  assert_not_nil assigns(:root_node)
  #end
  
  # no direct "new" action
  #test "should get new" do
  #  get :new
  #  assert_response :success
  #end
  
  test "should create node" do
    bypass_authentication
    
    assert_difference 'Node.count', +1 do
      xhr :post, :create,
        :user_id => users(:a_user).to_param,
        :pile_id => piles(:a_pile).to_param,
        :node => {
          :parent_id => nodes(:a_piles_root_node).to_param,
          :prop_type => 'text',
          :prop_attributes => {:value => "a test node's text"}
        }
      
      assert_response :success
    end
  end
  
  # no direct "update" action
  #test "should show node" do
  #  get :show, :id => nodes(:one).to_param
  #  assert_response :success
  #end
  
  # no direct "update" action
  #test "should get edit" do
  #  get :edit, :id => nodes(:one).to_param
  #  assert_response :success
  #end
  
  # no direct "update" action
  #test "should update node" do
  #  put :update, :id => nodes(:one).to_param, :node => { }
  #  assert_redirected_to node_path(assigns(:node))
  #end
  
  test "should destroy node" do
    bypass_authentication
    
    assert_difference 'Node.count', -1 do
      xhr :delete, :destroy,
        :user_id => users(:a_user).to_param,
        :pile_id => piles(:a_pile).to_param,
        :id => nodes(:a_plain_text_node).to_param
      
      assert_response :success
    end
  end
  
  
protected
  
  def bypass_authentication
    NodesController.any_instance.stubs :logged_in? => true, :current_user => users(:a_user)
  end
  
end
