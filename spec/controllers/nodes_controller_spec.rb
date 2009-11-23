require 'spec_helper'

describe NodesController do
  
  def mock_node(stubs={})
    @mock_node ||= mock_model(Node, stubs)
  end
  
  describe "GET index" do
    it "assigns all nodes as @nodes" #do
    #  Node.stub!(:find).with(:all).and_return([mock_node])
    #  get :index
    #  assigns[:nodes].should == [mock_node]
    #end
  end
  
  describe "GET show" do
    it "assigns the requested node as @node" #do
    #  Node.stub!(:find).with("37").and_return(mock_node)
    #  get :show, :id => "37"
    #  assigns[:node].should equal(mock_node)
    #end
  end
  
  describe "GET new" do
    it "assigns a new node as @node" #do
    #  Node.stub!(:new).and_return(mock_node)
    #  get :new
    #  assigns[:node].should equal(mock_node)
    #end
  end
  
  describe "GET edit" do
    it "assigns the requested node as @node" #do
    #  Node.stub!(:find).with("37").and_return(mock_node)
    #  get :edit, :id => "37"
    #  assigns[:node].should equal(mock_node)
    #end
  end
  
  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created node as @node" #do
      #  Node.stub!(:new).with({'these' => 'params'}).and_return(mock_node(:save => true))
      #  post :create, :node => {:these => 'params'}
      #  assigns[:node].should equal(mock_node)
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
      #  assigns[:node].should equal(mock_node)
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
      #  Node.should_receive(:find).with("37").and_return(mock_node)
      #  mock_node.should_receive(:update_attributes).with({'these' => 'params'})
      #  put :update, :id => "37", :node => {:these => 'params'}
      #end
      
      it "assigns the requested node as @node" #do
      #  Node.stub!(:find).and_return(mock_node(:update_attributes => true))
      #  put :update, :id => "1"
      #  assigns[:node].should equal(mock_node)
      #end
      
      it "redirects to the node" #do
      #  Node.stub!(:find).and_return(mock_node(:update_attributes => true))
      #  put :update, :id => "1"
      #  response.should redirect_to(node_url(mock_node))
      #end
    end
    
    describe "with invalid params" do
      it "updates the requested node" #do
      #  Node.should_receive(:find).with("37").and_return(mock_node)
      #  mock_node.should_receive(:update_attributes).with({'these' => 'params'})
      #  put :update, :id => "37", :node => {:these => 'params'}
      #end
      
      it "assigns the node as @node" #do
      #  Node.stub!(:find).and_return(mock_node(:update_attributes => false))
      #  put :update, :id => "1"
      #  assigns[:node].should equal(mock_node)
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
    #  Node.should_receive(:find).with("37").and_return(mock_node)
    #  mock_node.should_receive(:destroy)
    #  delete :destroy, :id => "37"
    #end
    
    it "redirects to the nodes list" #do
    #  Node.stub!(:find).and_return(mock_node(:destroy => true))
    #  delete :destroy, :id => "1"
    #  response.should redirect_to(nodes_url)
    #end
  end
  
end
