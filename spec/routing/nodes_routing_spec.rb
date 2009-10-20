require 'spec_helper'

describe NodesController do
  describe "routing" do
    
    it "recognizes and generates #index" do
      expected_path = '/test-user/piles/1/nodes'
      { :get => expected_path }.should route_to(:controller => 'nodes', :action => 'index', :user_id => 'test-user', :pile_id => '1')
      user_pile_nodes_path(:pile_id => 1, :user_id => 'test-user').should == expected_path
    end
    
    it "recognizes and generates #new" do
      expected_path = '/test-user/piles/1/nodes/new'
      { :get => expected_path }.should route_to(:controller => 'nodes', :action => 'new', :user_id => 'test-user', :pile_id => '1')
      new_user_pile_node_path(:pile_id => 1, :user_id => 'test-user').should == expected_path
    end
    
    it "recognizes and generates #show" do
      expected_path = '/test-user/piles/1/nodes/2'
      { :get => expected_path }.should route_to(:controller => 'nodes', :action => 'show', :user_id => 'test-user', :pile_id => '1', :id => '2')
      user_pile_node_path(:id => 2, :pile_id => 1, :user_id => 'test-user').should == expected_path
    end
    
    it "recognizes and generates #edit" do
      expected_path = '/test-user/piles/1/nodes/2/edit'
      { :get => expected_path }.should route_to(:controller => 'nodes', :action => 'edit', :user_id => 'test-user', :pile_id => '1', :id => '2')
      edit_user_pile_node_path(:id => 2, :pile_id => 1, :user_id => 'test-user').should == expected_path
    end
    
    it "recognizes and generates #create" do
      expected_path = '/test-user/piles/1/nodes'
      { :post => expected_path }.should route_to(:controller => 'nodes', :action => 'create', :user_id => 'test-user', :pile_id => '1')
      user_pile_nodes_path(:pile_id => 1, :user_id => 'test-user').should == expected_path
    end
    
    it "recognizes and generates #update" do
      expected_path = '/test-user/piles/1/nodes/2'
      { :put => expected_path }.should route_to(:controller => 'nodes', :action => 'update', :user_id => 'test-user', :pile_id => '1', :id => '2')
      user_pile_node_path(:id => 2, :pile_id => 1, :user_id => 'test-user').should == expected_path
    end
    
    it "recognizes and generates #destroy" do
      expected_path = '/test-user/piles/1/nodes/2'
      { :delete => expected_path }.should route_to(:controller => 'nodes', :action => 'destroy', :user_id => 'test-user', :pile_id => '1', :id => '2')
      user_pile_node_path(:id => 2, :pile_id => 1, :user_id => 'test-user').should == expected_path
    end
    
  end
end
