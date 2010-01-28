require 'spec_helper'

describe PilesController do
  include ActionController::PolymorphicRoutes
  
  
  before(:each) do
    @user = Factory.create(:user, :login => 'test-user')
    @pile = Factory.create(:pile, :id => 1, :owner => @user)
  end
  
  
  describe "routing" do
    
    it "recognizes and generates #index" do
      expected_path = '/test-user/piles'
      
      { :get => expected_path }.should route_to(:controller => 'piles', :action => 'index', :user_id => 'test-user')
      user_piles_path(:user_id => 'test-user').should == expected_path
      polymorphic_path([@user, :piles]).should == expected_path
    end
    
    it "recognizes and generates #new" do
      expected_path = '/test-user/piles/new'
      
      { :get => expected_path }.should route_to(:controller => 'piles', :action => 'new', :user_id => 'test-user')
      new_user_pile_path(:user_id => 'test-user').should == expected_path
      new_polymorphic_path([@user, :pile]).should == expected_path
      
      new_pile = Factory.build(:pile, :owner => @user)
      new_polymorphic_path([@user, new_pile]).should == expected_path
    end
    
    it "recognizes and generates #show" do
      expected_path = '/test-user/piles/1'
      
      { :get => expected_path }.should route_to(:controller => 'piles', :action => 'show', :user_id => 'test-user', :id => '1')
      user_pile_path(:id => 1, :user_id => 'test-user').should == expected_path
      polymorphic_path([@user, @pile]).should == expected_path
    end
    
    it "recognizes and generates #edit" do
      expected_path = '/test-user/piles/1/edit'
      
      { :get => expected_path }.should route_to(:controller => 'piles', :action => 'edit', :user_id => 'test-user', :id => '1')
      edit_user_pile_path(:id => 1, :user_id => 'test-user').should == expected_path
      edit_polymorphic_path([@user, @pile]).should == expected_path
    end
    
    it "recognizes and generates #create" do
      expected_path = '/test-user/piles'
      
      { :post => expected_path }.should route_to(:controller => 'piles', :action => 'create', :user_id => 'test-user')
      user_piles_path(:user_id => 'test-user').should == expected_path
      polymorphic_path([@user, :piles]).should == expected_path
    end
    
    it "recognizes and generates #update" do
      expected_path = '/test-user/piles/1'
      
      { :put => expected_path }.should route_to(:controller => 'piles', :action => 'update', :user_id => 'test-user', :id => '1')
      user_pile_path(:id => 1, :user_id => 'test-user').should == expected_path
      polymorphic_path([@user, @pile]).should == expected_path
    end
    
    it "recognizes and generates #destroy" do
      expected_path = '/test-user/piles/1'
      
      { :delete => expected_path }.should route_to(:controller => 'piles', :action => 'destroy', :user_id => 'test-user', :id => '1')
      user_pile_path(:id => 1, :user_id => 'test-user').should == expected_path
      polymorphic_path([@user, @pile]).should == expected_path
    end
    
  end
end
