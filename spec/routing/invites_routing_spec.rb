require 'spec_helper'

describe InvitesController do
  describe "routing" do
    
    it "recognizes and generates #index" do
      { :get => "/inv" }.should route_to(:controller => "invites", :action => "index")
    end
    
    it "recognizes and generates #new" do
      { :get => "/inv/new" }.should route_to(:controller => "invites", :action => "new")
    end
    
    it "recognizes and generates #show" do
      { :get => "/inv/1" }.should route_to(:controller => "invites", :action => "show", :id => "1")
    end
    
    it "recognizes and generates #edit" do
      { :get => "/inv/1/edit" }.should route_to(:controller => "invites", :action => "edit", :id => "1")
    end
    
    it "recognizes and generates #create" do
      { :post => "/inv" }.should route_to(:controller => "invites", :action => "create") 
    end
    
    it "recognizes and generates #update" do
      { :put => "/inv/1" }.should route_to(:controller => "invites", :action => "update", :id => "1") 
    end
    
    it "recognizes and generates #destroy" do
      { :delete => "/inv/1" }.should route_to(:controller => "invites", :action => "destroy", :id => "1") 
    end
    
  end
end
