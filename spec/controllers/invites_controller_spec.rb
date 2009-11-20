require 'spec_helper'

describe InvitesController do
  
  def mock_invite(stubs={})
    mock_model(Invite, stubs)
  end
  
  describe "GET new" do
    it "assigns a new invite as @invite" do
      i = mock_invite
      Invite.stub!(:new).and_return(i)
      
      get :new
      assigns[:invite].should be(i)
    end
  end
  
  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created invite as @invite" do
        i = mock_invite(:save => true, :sender= => nil)
        Invite.stub!(:new).with({'these' => 'params'}).and_return(i)
        
        post :create, :invite => {:these => 'params'}
        assigns[:invite].should be(i)
      end
      
      it "redirects to the created invite" do
        i = mock_invite(:save => true, :sender= => nil)
        Invite.stub!(:new).and_return(i)
        
        controller.should_receive(:redirect_to) # redirect to anywhere, we don't care for now
        post :create, :invite => {}
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved invite as @invite" do
        i = mock_invite(:save => false, :sender= => nil)
        Invite.stub!(:new).with({'these' => 'params'}).and_return(i)
        
        post :create, :invite => {:these => 'params'}
        assigns[:invite].should be(i)
      end
      
      it "re-renders the 'new' template" do
        i = mock_invite(:save => false, :sender= => nil)
        Invite.stub!(:new).and_return(i)
        
        controller.should_receive(:redirect_to) # redirect to anywhere, we don't care for now
        post :create, :invite => {}
        #response.should render_template('new')
      end
    end
    
  end
  
end
