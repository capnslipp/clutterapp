require 'spec_helper'

describe NodesController do
  describe "routing" do
    
    before(:each) do
      @user = Factory.create(:user)
      @pile = @user.default_pile
      @node = @pile.root_node
    end
    
    
    it "recognizes and generates #index" do
      { :get => "/#{@user.login}/piles/#{@pile.id}/nodes" }.should route_to(:controller => 'nodes', :action => 'index', :user_id => @user.to_param, :pile_id => @pile.id.to_s)
    end
    
    it "recognizes and generates #new" do
      { :get => "/#{@user.login}/piles/#{@pile.id}/nodes/new" }.should route_to(:controller => 'nodes', :action => 'new', :user_id => @user.to_param, :pile_id => @pile.id.to_s)
    end
    
    it "recognizes and generates #show" do
      { :get => "/#{@user.login}/piles/#{@pile.id}/nodes/#{@node.id}" }.should route_to(:controller => 'nodes', :action => 'show', :user_id => @user.to_param, :pile_id => @pile.id.to_s, :id => @node.id.to_s)
    end
    
    it "recognizes and generates #edit" do
      { :get => "/#{@user.login}/piles/#{@pile.id}/nodes/#{@node.id}/edit" }.should route_to(:controller => 'nodes', :action => 'edit', :user_id => @user.to_param, :pile_id => @pile.id.to_s, :id => @node.id.to_s)
    end
    
    it "recognizes and generates #create" do
      { :post => "/#{@user.login}/piles/#{@pile.id}/nodes" }.should route_to(:controller => 'nodes', :action => 'create', :user_id => @user.to_param, :pile_id => @pile.id.to_s)
    end
    
    it "recognizes and generates #update" do
      { :put => "/#{@user.login}/piles/#{@pile.id}/nodes/#{@node.id}" }.should route_to(:controller => 'nodes', :action => 'update', :user_id => @user.to_param, :pile_id => @pile.id.to_s, :id => @node.id.to_s)
    end
    
    it "recognizes and generates #destroy" do
      { :delete => "/#{@user.login}/piles/#{@pile.id}/nodes/#{@node.id}" }.should route_to(:controller => 'nodes', :action => 'destroy', :user_id => @user.to_param, :pile_id => @pile.id.to_s, :id => @node.id.to_s)
    end
    
  end
end
