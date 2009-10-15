require 'spec_helper'

describe UsersController do
  describe "routing" do
    
    before(:each) do
      @user = Factory.create(:user)
    end
    
    
    #it "recognizes and generates #index" do
    #  { :get => "/users" }.should route_to(:controller => 'users', :action => 'index')
    #end
    
    it "recognizes and generates #new" do
      { :get => "/sup" }.should route_to(:controller => 'users', :action => 'new')
    end
    
    it "recognizes and generates #show" do
      u = Factory.create(:user)
      { :get => "/#{@user.login}" }.should route_to(:controller => 'users', :action => 'show', :id => @user.to_param)
    end
    
    it "recognizes and generates #edit" do
      u = Factory.create(:user)
      { :get => "/#{@user.login}/edit" }.should route_to(:controller => 'users', :action => 'edit', :id => @user.to_param)
    end
    
    it "recognizes and generates #create" do
      { :post => "/reg" }.should route_to(:controller => 'users', :action => 'create')
    end
    
    it "recognizes and generates #update" do
      u = Factory.create(:user)
      { :put => "/#{@user.login}" }.should route_to(:controller => 'users', :action => 'update', :id => @user.to_param)
    end
    
    it "recognizes and generates #destroy" do
      u = Factory.create(:user)
      { :delete => "/#{@user.login}" }.should route_to(:controller => 'users', :action => 'destroy', :id => @user.to_param)
    end
    
  end
end
