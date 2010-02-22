require 'spec_helper'

describe UsersController do
  include ActionController::PolymorphicRoutes
  dataset :users
  
  
  before(:each) do
    @user = users(:slippy_douglas)
  end
  
  
  describe "routing" do
    
    #it "recognizes and generates #index" do
    #  expected_path = '/users'
    #  { :get => "/users" }.should route_to(:controller => 'users', :action => 'index')
    #  users_path().should == expected_path
    #end
    
    it "recognizes and generates #new" do
      expected_path = '/sup'
      
      { :get => expected_path }.should route_to(:controller => 'users', :action => 'new')
      new_user_path().should == expected_path
      new_polymorphic_path([:user]).should == expected_path
      
      new_user = User.new
      new_polymorphic_path([new_user]).should == expected_path
    end
    
    it "recognizes and generates #new with an invite_token" do
      expected_path = '/sup?invite_token=a'
      
      { :get => expected_path }.should route_to(:controller => 'users', :action => 'new', :invite_token => 'a')
      new_user_path(:invite_token => 'a').should == expected_path
    end
    
    it "recognizes and generates #show" do
      expected_path = '/slippy_douglas'
      
      { :get => expected_path }.should route_to(:controller => 'users', :action => 'show', :id => 'slippy_douglas')
      user_path('slippy_douglas').should == expected_path
      polymorphic_path([@user]).should == expected_path
    end
    
    it "recognizes and generates #edit" do
      expected_path = '/slippy_douglas/edit'
      
      { :get => expected_path }.should route_to(:controller => 'users', :action => 'edit', :id => 'slippy_douglas')
      edit_user_path('slippy_douglas').should == expected_path
      edit_polymorphic_path([@user]).should == expected_path
    end
    
    it "recognizes and generates #create" do
      expected_path = '/reg'
      
      { :post => expected_path }.should route_to(:controller => 'users', :action => 'create')
      users_path().should == expected_path
      polymorphic_path([:users]).should == expected_path
    end
    
    it "recognizes and generates #update" do
      expected_path = '/slippy_douglas'
      
      { :put => expected_path }.should route_to(:controller => 'users', :action => 'update', :id => 'slippy_douglas')
      user_path('slippy_douglas').should == expected_path
      polymorphic_path([@user]).should == expected_path
    end
    
    it "recognizes and generates #destroy" do
      expected_path = '/slippy_douglas'
      
      { :delete => expected_path }.should route_to(:controller => 'users', :action => 'destroy', :id => 'slippy_douglas')
      user_path('slippy_douglas').should == expected_path
      polymorphic_path([@user]).should == expected_path
    end
    
  end
end
