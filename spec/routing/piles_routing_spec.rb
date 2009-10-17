require 'spec_helper'

describe PilesController do
  describe "routing" do
    
    before(:each) do
      @user = Factory.create(:user)
      @pile = @user.default_pile
    end
    
    
    it "recognizes and generates #index" do
      { :get => "/test-user/piles" }.should route_to(:controller => 'piles', :action => 'index', :user_id => 'test-user')
    end
    
    it "recognizes and generates #new" do
      { :get => "/test-user/piles/new" }.should route_to(:controller => 'piles', :action => 'new', :user_id => 'test-user')
    end
    
    it "recognizes and generates #show" do
      { :get => "/test-user/piles/1" }.should route_to(:controller => 'piles', :action => 'show', :user_id => 'test-user', :id => '1')
    end
    
    it "recognizes and generates #edit" do
      { :get => "/test-user/piles/1/edit" }.should route_to(:controller => 'piles', :action => 'edit', :user_id => 'test-user', :id => '1')
    end
    
    it "recognizes and generates #create" do
      { :post => "/test-user/piles" }.should route_to(:controller => 'piles', :action => 'create', :user_id => 'test-user')
    end
    
    it "recognizes and generates #update" do
      { :put => "/test-user/piles/1" }.should route_to(:controller => 'piles', :action => 'update', :user_id => 'test-user', :id => '1')
    end
    
    it "recognizes and generates #destroy" do
      { :delete => "/test-user/piles/1" }.should route_to(:controller => 'piles', :action => 'destroy', :user_id => 'test-user', :id => '1')
    end
    
  end
end
