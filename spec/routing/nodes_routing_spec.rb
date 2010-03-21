require 'spec_helper'

describe NodesController do
  include ActionController::PolymorphicRoutes
  dataset :users, :piles, :nodes
  
  
  before(:each) do
    @user = users(:slippy_douglas)
    @pile = piles(:slippys)
    @node = nodes(:a_plain_text_node)
  end
    
   
   describe "routing" do
     
     # valid routes
     
     it "recognizes and generates #new" do
       expected_path = "/slippy_douglas/piles/#{@pile.id}/nodes/new"
       
       { :get => expected_path }.should route_to(:controller => 'nodes', :action => 'new', :user_id => 'slippy_douglas', :pile_id => "#{@pile.id}")
       
       new_user_pile_node_path(:pile_id => @pile.id, :user_id => 'slippy_douglas').should == expected_path
       new_polymorphic_path([@user, @pile, :node]).should == expected_path
       
       new_node = @pile.root_node.children.build
       new_polymorphic_path([@user, @pile, new_node]).should == expected_path
     end
     
     it "recognizes and generates #edit" do
       expected_path = "/slippy_douglas/piles/#{@pile.id}/nodes/#{@node.id}/edit"
       
       { :get => expected_path }.should route_to(:controller => 'nodes', :action => 'edit', :user_id => 'slippy_douglas', :pile_id => "#{@pile.id}", :id => "#{@node.id}")
       
       edit_user_pile_node_path(:id => @node.id, :pile_id => @pile.id, :user_id => 'slippy_douglas').should == expected_path
       edit_polymorphic_path([@user, @pile, @node]).should == expected_path
     end
     
     it "recognizes and generates #create" do
       expected_path = "/slippy_douglas/piles/#{@pile.id}/nodes"
       
       { :post => expected_path }.should route_to(:controller => 'nodes', :action => 'create', :user_id => 'slippy_douglas', :pile_id => "#{@pile.id}")
       
       user_pile_nodes_path(:pile_id => @pile.id, :user_id => 'slippy_douglas').should == expected_path
       polymorphic_path([@user, @pile, :nodes]).should == expected_path
     end
     
     it "recognizes and generates #update" do
       expected_path = "/slippy_douglas/piles/#{@pile.id}/nodes/#{@node.id}"
       
       { :put => expected_path }.should route_to(:controller => 'nodes', :action => 'update', :user_id => 'slippy_douglas', :pile_id => "#{@pile.id}", :id => "#{@node.id}")
       
       user_pile_node_path(:id => @node.id, :pile_id => @pile.id, :user_id => 'slippy_douglas').should == expected_path
       polymorphic_path([@user, @pile, @node]).should == expected_path
     end
     
     it "recognizes and generates #destroy" do
       expected_path = "/slippy_douglas/piles/#{@pile.id}/nodes/#{@node.id}"
       
       { :delete => expected_path }.should route_to(:controller => 'nodes', :action => 'destroy', :user_id => 'slippy_douglas', :pile_id => "#{@pile.id}", :id => "#{@node.id}")
       
       user_pile_node_path(:id => @node.id, :pile_id => @pile.id, :user_id => 'slippy_douglas').should == expected_path
       polymorphic_path([@user, @pile, @node]).should == expected_path
     end
     
     it "recognizes and generates #reorder" do
       expected_path = "/slippy_douglas/piles/#{@pile.id}/nodes/#{@node.id}/reorder"
       
       { :put => expected_path }.should route_to(:controller => 'nodes', :action => 'reorder', :user_id => 'slippy_douglas', :pile_id => "#{@pile.id}", :id => "#{@node.id}")
       
       reorder_user_pile_node_path(:id => @node.id, :pile_id => @pile.id, :user_id => 'slippy_douglas').should == expected_path
       polymorphic_path([:reorder, @user, @pile, @node]).should == expected_path
     end
     
     it "recognizes and generates #reparent" do
       expected_path = "/slippy_douglas/piles/#{@pile.id}/nodes/#{@node.id}/reparent"
       
       { :put => expected_path }.should route_to(:controller => 'nodes', :action => 'reparent', :user_id => 'slippy_douglas', :pile_id => "#{@pile.id}", :id => "#{@node.id}")
       
       reparent_user_pile_node_path(:id => @node.id, :pile_id => @pile.id, :user_id => 'slippy_douglas').should == expected_path
       polymorphic_path([:reparent, @user, @pile, @node]).should == expected_path
     end
     
     
     # invalid routes
     
     it "doesn't recognize and generate #index" do
       { :get => "/slippy_douglas/piles/#{@pile.id}/nodes" }.should_not be_routeable
     end
     
     #it "doesn't recognize and generate #show" do
     #  # still generating the route; Rails bug?
     #  { :get => "/slippy_douglas/piles/#{@pile.id}/nodes/#{@node.id}" }.should_not be_routeable
     #end
     
   end
end
