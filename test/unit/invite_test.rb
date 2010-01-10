require 'test_helper'

class InviteTest < ActiveSupport::TestCase
  def test_new_invite_with_recipent_email_should_be_valid
    assert Invite.new(:recipient_email => 'test@example.com').valid?
  end
  
  def test_new_invite_should_not_be_valid
    assert !( Invite.new().valid? )
  end
end
