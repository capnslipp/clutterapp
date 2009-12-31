require 'spec_helper'

describe NodesController do
  integrate_views
  
  before(:each) do
    activate_authlogic
    login
    controller.stub!(:have_owner).and_return(true)
    controller.stub!(:have_pile).and_return(true)
  end
  
  
  
  describe "GET new" do
    it "assigns a new node as @node" #do
    #  Node.stub!(:new).and_return(mock_node)
    #  
    #  get :new
    #end
  end
  
  describe "GET edit" do
    it "renders the edit form" do
      # mock and stub necessary input
      active_pile_nodes = mock(Object)
      active_pile_nodes.stub(:find).with('26').and_return(
        node = active_pile.root_node.children.create!(Factory.attributes_for :node, :prop => (Factory.build :text_prop))
      )
      controller.active_pile.stub(:nodes).and_return active_pile_nodes
      
      # make the request
      xhr :get, :edit, :id => '26', :pile_id => '1', :user_id => 'test-user'
      
      # check the response
      response.should be_success
      response.body.should be_present
      response.body.should have_tag('.edit.body')
      response.body.should have_tag('form')
    end
    
    it "renders the edit form with added Prop" do
      # mock and stub necessary input
      active_pile_nodes = mock(Object)
      active_pile_nodes.stub(:find).with('26').and_return(
        node = active_pile.root_node.children.create!(Factory.attributes_for :node, :prop => (Factory.build :text_prop))
      )
      controller.active_pile.stub(:nodes).and_return active_pile_nodes
      
      # make the request
      xhr :get, :edit, :id => '26', :pile_id => '1', :user_id => 'test-user', :add => {:prop_type => 'check'}
      
      # check the response
      response.should be_success
      response.body.should be_present
      response.body.should have_tag('.edit.body')
      response.body.should have_tag('form')
      response.body.should have_tag('input[type=checkbox]')
    end
  end
  
  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created node as @node" #do
      #  Node.stub!(:new).with({'these' => 'params'}).and_return(mock_node(:save => true))
      #  post :create, :node => {:these => 'params'}
      #end
      
      it "redirects to the created node" #do
      #  Node.stub!(:new).and_return(mock_node(:save => true))
      #  post :create, :node => {}
      #  response.should redirect_to(node_url(mock_node))
      #end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved node as @node" #do
      #  Node.stub!(:new).with({'these' => 'params'}).and_return(mock_node(:save => false))
      #  post :create, :node => {:these => 'params'}
      #end
      
      it "re-renders the 'new' template" #do
      #  Node.stub!(:new).and_return(mock_node(:save => false))
      #  post :create, :node => {}
      #  response.should render_template('new')
      #end
    end
    
  end
  
  describe "PUT update" do
    
    describe "with valid params" do
      it "updates the requested node" #do
      #  Node.should_receive(:find).with("26").and_return(mock_node)
      #  mock_node.should_receive(:update_attributes).with({'these' => 'params'})
      #  put :update, :id => "26", :node => {:these => 'params'}
      #end
      
      it "assigns the requested node as @node" #do
      #  Node.stub!(:find).and_return(mock_node(:update_attributes => true))
      #  put :update, :id => "1"
      #end
      
      it "redirects to the node" #do
      #  Node.stub!(:find).and_return(mock_node(:update_attributes => true))
      #  put :update, :id => "1"
      #  response.should redirect_to(node_url(mock_node))
      #end
    end
    
    describe "with invalid params" do
      it "updates the requested node" #do
      #  Node.should_receive(:find).with("26").and_return(mock_node)
      #  mock_node.should_receive(:update_attributes).with({'these' => 'params'})
      #  put :update, :id => "26", :node => {:these => 'params'}
      #end
      
      it "assigns the node as @node" #do
      #  Node.stub!(:find).and_return(mock_node(:update_attributes => false))
      #  put :update, :id => "1"
      #end
      
      it "re-renders the 'edit' template" #do
      #  Node.stub!(:find).and_return(mock_node(:update_attributes => false))
      #  put :update, :id => "1"
      #  response.should render_template('edit')
      #end
    end
    
  end
  
  describe "DELETE destroy" do
    it "destroys the requested node" #do
    #  Node.should_receive(:find).with("26").and_return(mock_node)
    #  mock_node.should_receive(:destroy)
    #  delete :destroy, :id => "26"
    #end
    
    it "redirects to the nodes list" #do
    #  Node.stub!(:find).and_return(mock_node(:destroy => true))
    #  delete :destroy, :id => "1"
    #  response.should redirect_to(nodes_url)
    #end
  end
  
end
