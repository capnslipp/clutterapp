require 'spec_helper'

describe UsersController do
  describe "routing" do
    #it "recognizes and generates #index" do
    #  { :get => "/users" }.should route_to(:controller => 'users', :action => 'index')
    #end
    
    it "recognizes and generates #new" do
      { :get => "/sup" }.should route_to(:controller => 'users', :action => 'new')
    end
    
    it "recognizes and generates #show" do
      u = Factory.create(:user)
      { :get => "/#{u.login}" }.should route_to(:controller => 'users', :action => 'show', :id => u.to_param)
    end
    
    it "recognizes and generates #edit" do
      u = Factory.create(:user)
      { :get => "/#{u.login}/edit" }.should route_to(:controller => 'users', :action => 'edit', :id => u.to_param)
    end
    
    it "recognizes and generates #create" do
      { :post => "/reg" }.should route_to(:controller => 'users', :action => 'create')
    end
    
    it "recognizes and generates #update" do
      u = Factory.create(:user)
      { :put => "/#{u.login}" }.should route_to(:controller => 'users', :action => 'update', :id => u.to_param)
    end
    
    it "recognizes and generates #destroy" do
      u = Factory.create(:user)
      { :delete => "/#{u.login}" }.should route_to(:controller => 'users', :action => 'destroy', :id => u.to_param)
    end
  end
end
