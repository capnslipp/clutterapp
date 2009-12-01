# require 'spec_helper'
# 
# describe NodesController do
#   include ActionController::PolymorphicRoutes
#   
#   
#   before(:each) do
#     @user = Factory.create(:user, :login => 'test-user')
#     @pile = Factory.create(:pile, :id => 1, :owner => @user)
#     
#     prop = Factory.build(:text_prop)
#     @node = Factory.create(:node, :id => 2, :pile => @pile, :parent => @pile.root_node, :prop => prop)
#   end
#     
#    
#    describe "routing" do
#      
#      # valid routes
#      
#      it "recognizes and generates #new" do
#        expected_path = '/test-user/piles/1/nodes/new'
#        
#        { :get => expected_path }.should route_to(:controller => 'nodes', :action => 'new', :user_id => 'test-user', :pile_id => '1')
#        new_user_pile_node_path(:pile_id => 1, :user_id => 'test-user').should == expected_path
#        new_polymorphic_path([@user, @pile, :node]).should == expected_path
#        
#        new_node = Factory.build(:node, :pile => @pile, :parent => @pile.root_node)
#        new_polymorphic_path([@user, @pile, new_node]).should == expected_path
#      end
#      
#      it "recognizes and generates #edit" do
#        expected_path = '/test-user/piles/1/nodes/2/edit'
#        
#        { :get => expected_path }.should route_to(:controller => 'nodes', :action => 'edit', :user_id => 'test-user', :pile_id => '1', :id => '2')
#        edit_user_pile_node_path(:id => 2, :pile_id => 1, :user_id => 'test-user').should == expected_path
#        edit_polymorphic_path([@user, @pile, @node]).should == expected_path
#      end
#      
#      it "recognizes and generates #create" do
#        expected_path = '/test-user/piles/1/nodes'
#        
#        { :post => expected_path }.should route_to(:controller => 'nodes', :action => 'create', :user_id => 'test-user', :pile_id => '1')
#        user_pile_nodes_path(:pile_id => 1, :user_id => 'test-user').should == expected_path
#        polymorphic_path([@user, @pile, :nodes]).should == expected_path
#      end
#      
#      it "recognizes and generates #update" do
#        expected_path = '/test-user/piles/1/nodes/2'
#        
#        { :put => expected_path }.should route_to(:controller => 'nodes', :action => 'update', :user_id => 'test-user', :pile_id => '1', :id => '2')
#        user_pile_node_path(:id => 2, :pile_id => 1, :user_id => 'test-user').should == expected_path
#        polymorphic_path([@user, @pile, @node]).should == expected_path
#      end
#      
#      it "recognizes and generates #destroy" do
#        expected_path = '/test-user/piles/1/nodes/2'
#        
#        { :delete => expected_path }.should route_to(:controller => 'nodes', :action => 'destroy', :user_id => 'test-user', :pile_id => '1', :id => '2')
#        user_pile_node_path(:id => 2, :pile_id => 1, :user_id => 'test-user').should == expected_path
#        polymorphic_path([@user, @pile, @node]).should == expected_path
#      end
#      
#      it "recognizes and generates #move" do
#        expected_path = '/test-user/piles/1/nodes/2/move'
#        
#        { :put => expected_path }.should route_to(:controller => 'nodes', :action => 'move', :user_id => 'test-user', :pile_id => '1', :id => '2')
#        move_user_pile_node_path(:id => 2, :pile_id => 1, :user_id => 'test-user').should == expected_path
#        polymorphic_path([:move, @user, @pile, @node]).should == expected_path
#      end
#      
#      
#      # invalid routes
#      
#      it "doesn't recognize and generate #index" do
#        { :get => '/test-user/piles/1/nodes' }.should_not be_routeable
#      end
#      
#      # doesn't work; Rails bug?
#      it "doesn't recognize and generate #show" #do
#      #  { :get => '/test-user/piles/1/nodes/2' }.should_not be_routeable
#      #end
#      
#    end
# end
