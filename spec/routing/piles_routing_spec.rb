require 'spec_helper'

describe PilesController do
  describe "routing" do
    
    before(:each) do
      @user = Factory.create(:user)
      @pile = @user.default_pile
    end
    
    
    it "recognizes and generates #index" do
      { :get => "/#{@user.login}/piles" }.should route_to(:controller => 'piles', :action => 'index', :user_id => @user.to_param)
    end
    
    it "recognizes and generates #new" do
      { :get => "/#{@user.login}/piles/new" }.should route_to(:controller => 'piles', :action => 'new', :user_id => @user.to_param)
    end
    
    it "recognizes and generates #show" do
      { :get => "/#{@user.login}/piles/#{@pile.id}" }.should route_to(:controller => 'piles', :action => 'show', :user_id => @user.to_param, :id => @pile.id.to_s)
    end
    
    it "recognizes and generates #edit" do
      { :get => "/#{@user.login}/piles/#{@pile.id}/edit" }.should route_to(:controller => 'piles', :action => 'edit', :user_id => @user.to_param, :id => @pile.id.to_s)
    end
    
    it "recognizes and generates #create" do
      { :post => "/#{@user.login}/piles" }.should route_to(:controller => 'piles', :action => 'create', :user_id => @user.to_param)
    end
    
    it "recognizes and generates #update" do
      { :put => "/#{@user.login}/piles/#{@pile.id}" }.should route_to(:controller => 'piles', :action => 'update', :user_id => @user.to_param, :id => @pile.id.to_s)
    end
    
    it "recognizes and generates #destroy" do
      { :delete => "/#{@user.login}/piles/#{@pile.id}" }.should route_to(:controller => 'piles', :action => 'destroy', :user_id => @user.to_param, :id => @pile.id.to_s)
    end
    
  end
end
