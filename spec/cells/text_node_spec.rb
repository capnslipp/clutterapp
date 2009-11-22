require 'spec_helper'

describe TextNodeCell do
  
  def mock_node(stubs={})
    @node ||= mock_model(Node, stubs)
  end
  
  #describe "GET index" do
  #  it "assigns all invites as @invites" do
  #    Invite.stub!(:find).with(:all).and_return([mock_invite])
  #    get :index
  #    assigns[:invites].should == [mock_invite]
  #  end
  #end
  
end
