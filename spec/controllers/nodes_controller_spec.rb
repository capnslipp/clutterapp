require 'spec_helper'

describe NodesController do
  integrate_views
  
  before(:each) do
    activate_authlogic
    login
    controller.stub!(:have_owner).and_return(true)
    controller.stub!(:have_pile).and_return(true)
  end
  
  # for some reason, this works when called as a method, but not in the before(:each)
  def mock_node
    @mock_node ||= active_pile.root_node.children.create!(Factory.attributes_for :node, :prop => (Factory.build :text_prop))
  end
  
  
  
  describe "GET new" do
    it "works" do
      # mock and stub necessary input
      active_pile_nodes = mock(Object)
      active_pile_nodes.stub(:find).with('26').and_return(mock_node)
      
      controller.should_receive(:active_pile).and_return(active_pile)
      active_pile.should_receive(:nodes).and_return(active_pile_nodes)
      
      model_counts = {
        Pile => Pile.count,
        Node => Node.count,
        TextProp => TextProp.count
      }
      
      # make the request
      xhr :get, :new,
        :pile_id => '1',
        :user_id => 'test-user',
        :node => {:prop_type => 'text', :parent_id => '26'}
      
      # check the response
      response.should be_success
      response.body.should be_present
      response.body.should have_tag('.new.body')
      response.body.should have_tag('form')
      model_counts.each do |t, oc|
        t.count.should == oc
      end
    end
    
    it "works with added Prop" do
      # mock and stub necessary input
      active_pile_nodes = mock(Object)
      active_pile_nodes.stub(:find).with('26').and_return(mock_node)
      
      controller.should_receive(:active_pile).and_return(active_pile)
      active_pile.should_receive(:nodes).and_return(active_pile_nodes)
      
      model_counts = {
        Pile => Pile.count,
        Node => Node.count,
        TextProp => TextProp.count,
        CheckProp => CheckProp.count
      }
      
      # make the request
      xhr :get, :new,
        :pile_id => '1',
        :user_id => 'test-user',
        :node => {:prop_type => 'text', :parent_id => '26'},
        :add => {:prop_type => 'check'}
      
      # check the response
      response.should be_success
      response.body.should be_present
      response.body.should have_tag('.new.body')
      response.body.should have_tag('form')
      response.body.should have_tag('input[type=checkbox]')
      model_counts.each do
        |t, oc| t.count.should == oc
      end
    end
    
    it "assigns a new node as @node" #do
    #  Node.stub!(:new).and_return(mock_node)
    #  
    #  get :new
    #end
  end
  
  describe "GET edit" do
    it "works" do
      # mock and stub necessary input
      active_pile_nodes = mock(Object)
      active_pile_nodes.should_receive(:find).with('26').and_return(mock_node)
      
      controller.should_receive(:active_pile).and_return(active_pile)
      active_pile.should_receive(:nodes).and_return(active_pile_nodes)
      
      model_counts = {
        Pile => Pile.count,
        Node => Node.count,
        TextProp => TextProp.count
      }
      
      # make the request
      xhr :get, :edit,
        :id => '26',
        :pile_id => '1',
        :user_id => 'test-user'
      
      # check the response
      response.should be_success
      response.body.should be_present
      response.body.should have_tag('.edit.body')
      response.body.should have_tag('form')
      model_counts.each do |t, oc|
        t.count.should == oc
      end
    end
    
    it "works with added Prop" do
      # mock and stub necessary input
      active_pile_nodes = mock(Object)
      active_pile_nodes.should_receive(:find).with('26').and_return(mock_node)
      
      controller.should_receive(:active_pile).and_return(active_pile)
      active_pile.should_receive(:nodes).and_return(active_pile_nodes)
      
      model_counts = {
        Pile => Pile.count,
        Node => Node.count,
        TextProp => TextProp.count,
        CheckProp => CheckProp.count
      }
      
      # make the request
      xhr :get, :edit,
        :id => '26',
        :pile_id => '1',
        :user_id => 'test-user',
        :add => {:prop_type => 'check'}
      
      # check the response
      response.should be_success
      response.body.should be_present
      response.body.should have_tag('.edit.body')
      response.body.should have_tag('form')
      response.body.should have_tag('input[type=checkbox]')
      model_counts.each do
        |t, oc| t.count.should == oc
      end
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
    it "works" do
      model_counts = {
        Pile => Pile.count,
        Node => Node.count,
        TextProp => TextProp.count
      }
      puts model_counts.to_s
      
      # mock and stub necessary input
      active_pile_nodes = mock(Object)
      active_pile_nodes.should_receive(:find).with('26').and_return(mock_node)
      
      controller.should_receive(:active_pile).and_return(active_pile)
      active_pile.should_receive(:nodes).and_return(active_pile_nodes)
      mock_node.should_receive(:destroy)
      
      model_counts = {
        Pile => Pile.count,
        Node => Node.count,
        TextProp => TextProp.count
      }
      puts model_counts.to_s
      
      # make the request
      xhr :delete, :destroy,
        :id => '26',
        :pile_id => '1',
        :user_id => 'test-user'
      
      # check the response
      puts model_counts.to_s
      response.should be_success
      Pile.count.should == model_counts[Pile]
      Node.count.should == model_counts[Node] - 1
      TextProp.count.should == model_counts[TextProp] - 1
    end
  end
  
end
