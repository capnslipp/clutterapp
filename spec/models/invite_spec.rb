require 'spec_helper'

describe Invite do
  dataset :users
  
  
  before(:each) do
  end
  
  it "should report invalid, given zero invites_remaining" do
    u = users(:a_user)
    u.stub!(:invites_remaining).and_return(0)
    
    u.errors.should_not be_nil
  end
  
  it "should increase its invite_sent_count when increment_sender_invite_sent_count is called" do
    i = Invite.create(:sender => users(:a_user))
    
    proc {
      i.send(:increment_sender_invite_sent_count)
    }.should change(i.sender, :invite_sent_count).by(1)
  end
  
end
