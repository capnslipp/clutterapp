require 'spec_helper'

describe NodesController do
  describe "routing" do
    
    before(:each) do
      @user = Factory.create(:user)
      @pile = @user.default_pile
      @node = @pile.root_node
    end
    
    
    it "recognizes and generates #index" do
      { :get => "/test-user/piles/1/nodes" }.should route_to(:controller => 'nodes', :action => 'index', :user_id => 'test-user', :pile_id => '1')
    end
    
    it "recognizes and generates #new" do
      { :get => "/test-user/piles/1/nodes/new" }.should route_to(:controller => 'nodes', :action => 'new', :user_id => 'test-user', :pile_id => '1')
    end
    
    it "recognizes and generates #show" do
      { :get => "/test-user/piles/1/nodes/2" }.should route_to(:controller => 'nodes', :action => 'show', :user_id => 'test-user', :pile_id => '1', :id => '2')
    end
    
    it "recognizes and generates #edit" do
      { :get => "/test-user/piles/1/nodes/2/edit" }.should route_to(:controller => 'nodes', :action => 'edit', :user_id => 'test-user', :pile_id => '1', :id => '2')
    end
    
    it "recognizes and generates #create" do
      { :post => "/test-user/piles/1/nodes" }.should route_to(:controller => 'nodes', :action => 'create', :user_id => 'test-user', :pile_id => '1')
    end
    
    it "recognizes and generates #update" do
      { :put => "/test-user/piles/1/nodes/2" }.should route_to(:controller => 'nodes', :action => 'update', :user_id => 'test-user', :pile_id => '1', :id => '2')
    end
    
    it "recognizes and generates #destroy" do
      { :delete => "/test-user/piles/1/nodes/2" }.should route_to(:controller => 'nodes', :action => 'destroy', :user_id => 'test-user', :pile_id => '1', :id => '2')
    end
    
  end
end
