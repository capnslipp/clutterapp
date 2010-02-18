require 'spec_helper'

describe FollowshipsController do
  include ActionController::PolymorphicRoutes
  dataset :users
  
  
  before(:each) do
    @user1 = users(:slippy_douglas)
    @user2 = users(:josh_vera)
    @followship = Followship.create(
      :user => @user1,
      :followee => @user2,
      :id => 256
    )
  end
  
  # 
  # describe "routing" do
  #   
  #   # valid routes
  #   
  #   it "recognizes and generates #create" # do
  #   #       expected_path = '/username1/followships'
  #   #       params_from(:post, expected_path).should == {:controller => 'followships', :action => 'create', :user_id => 'username1'}
  #   #       #{ :post => expected_path }.should route_to(:controller => 'followships', :action => 'create', :user_id => 'username1')
  #   #       user_followships_path().should == expected_path
  #   #       polymorphic_path([@user][@followships]).should == expected_path
  #   #     end
  #   
  #   it "recognizes and generates #destroy" # do
  #   #       expected_path = '/username1/256'
  #   #       
  #   #       { :delete => expected_path }.should route_to(:controller => 'followships', :action => 'destroy', :id => '256')
  #   #       followship_path(256).should == expected_path
  #   #       polymorphic_path([@followship]).should == expected_path
  #   #     end
  #   
  #   it "recognizes and generates #following" # do
  #   #       expected_path = '/username1/following'
  #   #       { :get => expected_path }.should route_to(:controller => "followships", :action => 'following', :user_id => 'username1')
  #   #       polymorphic_path([@followship]).should == expected_path
  #   #     end
  #   
  #   it "recognizes and generates #followers" # do
  #   #       expected_path = '/username1/followers'
  #   #       { :get => expected_path }.should route_to(:controller => "followships", :action => 'followers', :user_id => 'username1')
  #   #       polymorphic_path([@followship]).should == expected_path
  #   #     end
  #   
  #   # invalid routes
  #   
  #   it "doesn't recognizs and generate #new" #do
  #   #  { :get => '/followships/new' }.should_not be_routable
  #   #end
  #   
  #   it "doesn't recognize and generate #show" #do
  #   #  { :get => '/followships/256' }.should_not be_routable
  #   #end
  #   
  #   it "doesn't recognize and generate #edit" #do
  #   #  { :get => '/followships/256/edit' }.should_not be_routable
  #   #end
  #   
  #   it "doesn't recognize and generate #update" #do
  #   #  { :put => '/followships/256' }.should_not be_routable
  #   #end
  #   
  # end
end
