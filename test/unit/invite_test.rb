require 'test_helper'

class InviteTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Invite.new(:recipient_email => 'test@example.com').valid?
  end
end
