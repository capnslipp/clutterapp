require 'spec_helper'

describe InvitesController do

  #def mock_invite(stubs={})
  #  @mock_invite ||= mock_model(Invite, stubs)
  #end
  #
  #describe "GET index" do
  #  it "assigns all invites as @invites" do
  #    Invite.stub!(:find).with(:all).and_return([mock_invite])
  #    get :index
  #    assigns[:invites].should == [mock_invite]
  #  end
  #end
  #
  #describe "GET show" do
  #  it "assigns the requested invite as @invite" do
  #    Invite.stub!(:find).with("37").and_return(mock_invite)
  #    get :show, :id => "37"
  #    assigns[:invite].should equal(mock_invite)
  #  end
  #end
  #
  #describe "GET new" do
  #  it "assigns a new invite as @invite" do
  #    Invite.stub!(:new).and_return(mock_invite)
  #    get :new
  #    assigns[:invite].should equal(mock_invite)
  #  end
  #end
  #
  #describe "GET edit" do
  #  it "assigns the requested invite as @invite" do
  #    Invite.stub!(:find).with("37").and_return(mock_invite)
  #    get :edit, :id => "37"
  #    assigns[:invite].should equal(mock_invite)
  #  end
  #end
  #
  #describe "POST create" do
  #
  #  describe "with valid params" do
  #    it "assigns a newly created invite as @invite" do
  #      Invite.stub!(:new).with({'these' => 'params'}).and_return(mock_invite(:save => true))
  #      post :create, :invite => {:these => 'params'}
  #      assigns[:invite].should equal(mock_invite)
  #    end
  #
  #    it "redirects to the created invite" do
  #      Invite.stub!(:new).and_return(mock_invite(:save => true))
  #      post :create, :invite => {}
  #      response.should redirect_to(invite_url(mock_invite))
  #    end
  #  end
  #
  #  describe "with invalid params" do
  #    it "assigns a newly created but unsaved invite as @invite" do
  #      Invite.stub!(:new).with({'these' => 'params'}).and_return(mock_invite(:save => false))
  #      post :create, :invite => {:these => 'params'}
  #      assigns[:invite].should equal(mock_invite)
  #    end
  #
  #    it "re-renders the 'new' template" do
  #      Invite.stub!(:new).and_return(mock_invite(:save => false))
  #      post :create, :invite => {}
  #      response.should render_template('new')
  #    end
  #  end
  #
  #end
  #
  #describe "PUT update" do
  #
  #  describe "with valid params" do
  #    it "updates the requested invite" do
  #      Invite.should_receive(:find).with("37").and_return(mock_invite)
  #      mock_invite.should_receive(:update_attributes).with({'these' => 'params'})
  #      put :update, :id => "37", :invite => {:these => 'params'}
  #    end
  #
  #    it "assigns the requested invite as @invite" do
  #      Invite.stub!(:find).and_return(mock_invite(:update_attributes => true))
  #      put :update, :id => "1"
  #      assigns[:invite].should equal(mock_invite)
  #    end
  #
  #    it "redirects to the invite" do
  #      Invite.stub!(:find).and_return(mock_invite(:update_attributes => true))
  #      put :update, :id => "1"
  #      response.should redirect_to(invite_url(mock_invite))
  #    end
  #  end
  #
  #  describe "with invalid params" do
  #    it "updates the requested invite" do
  #      Invite.should_receive(:find).with("37").and_return(mock_invite)
  #      mock_invite.should_receive(:update_attributes).with({'these' => 'params'})
  #      put :update, :id => "37", :invite => {:these => 'params'}
  #    end
  #
  #    it "assigns the invite as @invite" do
  #      Invite.stub!(:find).and_return(mock_invite(:update_attributes => false))
  #      put :update, :id => "1"
  #      assigns[:invite].should equal(mock_invite)
  #    end
  #
  #    it "re-renders the 'edit' template" do
  #      Invite.stub!(:find).and_return(mock_invite(:update_attributes => false))
  #      put :update, :id => "1"
  #      response.should render_template('edit')
  #    end
  #  end
  #
  #end
  #
  #describe "DELETE destroy" do
  #  it "destroys the requested invite" do
  #    Invite.should_receive(:find).with("37").and_return(mock_invite)
  #    mock_invite.should_receive(:destroy)
  #    delete :destroy, :id => "37"
  #  end
  #
  #  it "redirects to the invites list" do
  #    Invite.stub!(:find).and_return(mock_invite(:destroy => true))
  #    delete :destroy, :id => "1"
  #    response.should redirect_to(invites_url)
  #  end
  #end

end
