require 'spec_helper'

describe FollowshipsController do
  include ActionController::PolymorphicRoutes
  
  
  before(:each) do
    @followship = Factory.create(:followship, :id => 256)
  end
  
  
  describe "routing" do
    
    # valid routes
    
    it "recognizes and generates #index" do
      expected_path = '/followships'
      
      { :get => "/followships" }.should route_to(:controller => 'followships', :action => 'index')
      followships_path().should == expected_path
    end
    
    it "recognizes and generates #create" do
      expected_path = '/followships'
      
      { :post => expected_path }.should route_to(:controller => 'followships', :action => 'create')
      followships_path().should == expected_path
      polymorphic_path([:followships]).should == expected_path
    end
    
    it "recognizes and generates #destroy" do
      expected_path = '/followships/256'
      
      { :delete => expected_path }.should route_to(:controller => 'followships', :action => 'destroy', :id => '256')
      followship_path(256).should == expected_path
      polymorphic_path([@followship]).should == expected_path
    end
    
    
    # invalid routes
    
    it "doesn't recognizs and generate #new" #do
    #  { :get => '/followships/new' }.should_not be_routable
    #end
    
    it "doesn't recognize and generate #show" #do
    #  { :get => '/followships/256' }.should_not be_routable
    #end
    
    it "doesn't recognize and generate #edit" #do
    #  { :get => '/followships/256/edit' }.should_not be_routable
    #end
    
    it "doesn't recognize and generate #update" #do
    #  { :put => '/followships/256' }.should_not be_routable
    #end
    
  end
end
