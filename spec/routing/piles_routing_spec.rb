require 'spec_helper'

describe PilesController do
  describe "routing" do
    
    before(:each) do
      @user = Factory.create(:user)
      @pile = @user.default_pile
    end
    
    
    it "recognizes and generates #index" do
      expected_path = '/test-user/piles'
      { :get => expected_path }.should route_to(:controller => 'piles', :action => 'index', :user_id => 'test-user')
      user_piles_path(:user_id => 'test-user').should == expected_path
    end
    
    it "recognizes and generates #new" do
      expected_path = '/test-user/piles/new'
      { :get => expected_path }.should route_to(:controller => 'piles', :action => 'new', :user_id => 'test-user')
      new_user_pile_path(:user_id => 'test-user').should == expected_path
    end
    
    it "recognizes and generates #show" do
      expected_path = '/test-user/piles/1'
      { :get => expected_path }.should route_to(:controller => 'piles', :action => 'show', :user_id => 'test-user', :id => '1')
      user_pile_path(:id => 1, :user_id => 'test-user').should == expected_path
    end
    
    it "recognizes and generates #edit" do
      expected_path = '/test-user/piles/1/edit'
      { :get => expected_path }.should route_to(:controller => 'piles', :action => 'edit', :user_id => 'test-user', :id => '1')
      edit_user_pile_path(:id => 1, :user_id => 'test-user').should == expected_path
    end
    
    it "recognizes and generates #create" do
      expected_path = '/test-user/piles'
      { :post => expected_path }.should route_to(:controller => 'piles', :action => 'create', :user_id => 'test-user')
      user_piles_path(:user_id => 'test-user').should == expected_path
    end
    
    it "recognizes and generates #update" do
      expected_path = '/test-user/piles/1'
      { :put => expected_path }.should route_to(:controller => 'piles', :action => 'update', :user_id => 'test-user', :id => '1')
      user_pile_path(:id => 1, :user_id => 'test-user').should == expected_path
    end
    
    it "recognizes and generates #destroy" do
      expected_path = '/test-user/piles/1'
      { :delete => expected_path }.should route_to(:controller => 'piles', :action => 'destroy', :user_id => 'test-user', :id => '1')
      user_pile_path(:id => 1, :user_id => 'test-user').should == expected_path
    end
    
  end
end
