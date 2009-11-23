require 'spec_helper'

describe PilesController do
  
  def mock_pile(stubs={})
    @mock_pile ||= mock_model(Pile, stubs)
  end
  
  describe "GET index" do
    it "assigns all piles as @piles" #do
    #  Pile.stub!(:find).with(:all).and_return([mock_pile])
    #  get :index
    #  assigns[:piles].should == [mock_pile]
    #end
  end
  
  describe "GET show" do
    it "assigns the requested pile as @pile" #do
    #  Pile.stub!(:find).with("37").and_return(mock_pile)
    #  get :show, :id => "37"
    #  assigns[:pile].should equal(mock_pile)
    #end
  end
  
  describe "GET new" do
    it "assigns a new pile as @pile" #do
    #  Pile.stub!(:new).and_return(mock_pile)
    #  get :new
    #  assigns[:pile].should equal(mock_pile)
    #end
  end
  
  describe "GET edit" do
    it "assigns the requested pile as @pile" #do
    #  Pile.stub!(:find).with("37").and_return(mock_pile)
    #  get :edit, :id => "37"
    #  assigns[:pile].should equal(mock_pile)
    #end
  end
  
  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created pile as @pile" #do
      #  Pile.stub!(:new).with({'these' => 'params'}).and_return(mock_pile(:save => true))
      #  post :create, :pile => {:these => 'params'}
      #  assigns[:pile].should equal(mock_pile)
      #end
      
      it "redirects to the created pile" #do
      #  Pile.stub!(:new).and_return(mock_pile(:save => true))
      #  post :create, :pile => {}
      #  response.should redirect_to(pile_url(mock_pile))
      #end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved pile as @pile" #do
      #  Pile.stub!(:new).with({'these' => 'params'}).and_return(mock_pile(:save => false))
      #  post :create, :pile => {:these => 'params'}
      #  assigns[:pile].should equal(mock_pile)
      #end
      
      it "re-renders the 'new' template" #do
      #  Pile.stub!(:new).and_return(mock_pile(:save => false))
      #  post :create, :pile => {}
      #  response.should render_template('new')
      #end
    end
    
  end
  
  describe "PUT update" do
    
    describe "with valid params" do
      it "updates the requested pile" #do
      #  Pile.should_receive(:find).with("37").and_return(mock_pile)
      #  mock_pile.should_receive(:update_attributes).with({'these' => 'params'})
      #  put :update, :id => "37", :pile => {:these => 'params'}
      #end
      
      it "assigns the requested pile as @pile" #do
      #  Pile.stub!(:find).and_return(mock_pile(:update_attributes => true))
      #  put :update, :id => "1"
      #  assigns[:pile].should equal(mock_pile)
      #end
      
      it "redirects to the pile" #do
      #  Pile.stub!(:find).and_return(mock_pile(:update_attributes => true))
      #  put :update, :id => "1"
      #  response.should redirect_to(pile_url(mock_pile))
      #end
    end
  
    describe "with invalid params" do
      it "updates the requested pile" #do
      #  Pile.should_receive(:find).with("37").and_return(mock_pile)
      #  mock_pile.should_receive(:update_attributes).with({'these' => 'params'})
      #  put :update, :id => "37", :pile => {:these => 'params'}
      #end
      
      it "assigns the pile as @pile" #do
      #  Pile.stub!(:find).and_return(mock_pile(:update_attributes => false))
      #  put :update, :id => "1"
      #  assigns[:pile].should equal(mock_pile)
      #end
      
      it "re-renders the 'edit' template" #do
      #  Pile.stub!(:find).and_return(mock_pile(:update_attributes => false))
      #  put :update, :id => "1"
      #  response.should render_template('edit')
      #end
    end
  
  end
  
  describe "DELETE destroy" do
    it "destroys the requested pile" #do
    #  Pile.should_receive(:find).with("37").and_return(mock_pile)
    #  mock_pile.should_receive(:destroy)
    #  delete :destroy, :id => "37"
    #end
    
    it "redirects to the piles list" #do
    #  Pile.stub!(:find).and_return(mock_pile(:destroy => true))
    #  delete :destroy, :id => "1"
    #  response.should redirect_to(piles_url)
    #end
  end
  
end
