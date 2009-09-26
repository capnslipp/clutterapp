require 'test_helper'

class NodesControllerTest < ActionController::TestCase
  include NodesHelper
  
  #test "should get index" do
  #  bypass_authentication
  #  
  #  get :index, :user_id => users(:one).to_param
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
    
    # make sure our fixture user has a defpile and a root_node
    test_pile = users(:one).default_pile
    test_root_node = test_pile.root_node
    
    assert_difference 'Node.count', +1 do
      post :create, pile_nodes_url_hash(test_pile).merge( :pile_id => test_pile.to_param, :parent_id => test_root_node.to_param, :type => 'text' )
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
    
    test_should_create_node()
    test_pile = users(:one).default_pile
    test_root_node = test_pile.root_node
    
    assert_difference 'Node.count', -1 do
      delete :destroy, pile_nodes_url_hash(test_pile).merge( :pile_id => test_pile.to_param, :id => test_root_node.children.last.to_param )
    end
  end
  
  
protected
  
  def bypass_authentication
    NodesController.any_instance.stubs(:logged_in? => true, :current_user => User.first)
  end
  
end
