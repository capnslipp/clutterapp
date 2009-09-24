require 'test_helper'

class NodesControllerTest < ActionController::TestCase
  
  test "should get index" do
    bypass_authentication
    
    get :index, :user_id => users(:quentin).to_param
    assert_response :success
    assert_not_nil assigns(:root_node)
  end
  
  # no direct "new" action
  #test "should get new" do
  #  get :new
  #  assert_response :success
  #end
  
  test "should create node" do
    bypass_authentication
    
    # no idea why we need to do this first, but it fails if we don't
    users(:quentin).pile.root_node.create_child!({:prop => TextProp.filler})
    
    assert_difference 'Node.count', +1 do
      post :create, :parent_id => users(:quentin).pile.root_node.to_param, :type => 'text'
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
    
    users(:quentin).pile.root_node.create_child!({:prop => TextProp.filler})
    
    assert_difference 'Node.count', -1 do
      delete :destroy, :id => users(:quentin).pile.root_node.children.last.to_param
    end
  end
  
  
protected
  
  def bypass_authentication
    NodesController.any_instance.stubs(:logged_in? => true, :current_user => User.first)
  end
  
end
