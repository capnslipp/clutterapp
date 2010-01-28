require 'spec_helper'

describe PilesController do
  include ActionController::PolymorphicRoutes
  dataset :piles
  
  
  before(:each) do
    @user = users(:a_user)
    @pile = @user.default_pile
  end
  
  
  describe "routing" do
    
    it "recognizes and generates #index" do
      expected_path = "/a_user/piles"
      
      { :get => expected_path }.should route_to(:controller => 'piles', :action => 'index', :user_id => 'a_user')
      
      user_piles_path(:user_id => 'a_user').should == expected_path
      polymorphic_path([@user, :piles]).should == expected_path
    end
    
    it "recognizes and generates #new" do
      expected_path = "/a_user/piles/new"
      
      { :get => expected_path }.should route_to(:controller => 'piles', :action => 'new', :user_id => 'a_user')
      
      new_user_pile_path(:user_id => 'a_user').should == expected_path
      new_polymorphic_path([@user, :pile]).should == expected_path
      
      new_pile = @user.piles.build
      new_polymorphic_path([@user, new_pile]).should == expected_path
    end
    
    it "recognizes and generates #show" do
      expected_path = "/a_user/piles/#{@pile.id}"
      
      { :get => expected_path }.should route_to(:controller => 'piles', :action => 'show', :user_id => 'a_user', :id => "#{@pile.id}")
      
      user_pile_path(:id => @pile.id, :user_id => 'a_user').should == expected_path
      polymorphic_path([@user, @pile]).should == expected_path
    end
    
    it "recognizes and generates #edit" do
      expected_path = "/a_user/piles/#{@pile.id}/edit"
      
      { :get => expected_path }.should route_to(:controller => 'piles', :action => 'edit', :user_id => 'a_user', :id => "#{@pile.id}")
      
      edit_user_pile_path(:id => @pile.id, :user_id => 'a_user').should == expected_path
      edit_polymorphic_path([@user, @pile]).should == expected_path
    end
    
    it "recognizes and generates #create" do
      expected_path = "/a_user/piles"
      
      { :post => expected_path }.should route_to(:controller => 'piles', :action => 'create', :user_id => 'a_user')
      
      user_piles_path(:user_id => 'a_user').should == expected_path
      polymorphic_path([@user, :piles]).should == expected_path
    end
    
    it "recognizes and generates #update" do
      expected_path = "/a_user/piles/#{@pile.id}"
      
      { :put => expected_path }.should route_to(:controller => 'piles', :action => 'update', :user_id => 'a_user', :id => "#{@pile.id}")
      
      user_pile_path(:id => @pile.id, :user_id => 'a_user').should == expected_path
      polymorphic_path([@user, @pile]).should == expected_path
    end
    
    it "recognizes and generates #destroy" do
      expected_path = "/a_user/piles/#{@pile.id}"
      
      { :delete => expected_path }.should route_to(:controller => 'piles', :action => 'destroy', :user_id => 'a_user', :id => "#{@pile.id}")
      
      user_pile_path(:id => @pile.id, :user_id => 'a_user').should == expected_path
      polymorphic_path([@user, @pile]).should == expected_path
    end
    
  end
end
