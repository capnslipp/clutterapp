require 'test_helper'

class NodeTest < ActiveSupport::TestCase
  
  test "creating 2 users should result in 2 additional nodes" do
    assert_difference 'Node.count', +2 do
      u1 = create_user(:login => 'user1__', :email => 'user1__@example.com')
      u2 = create_user(:login => 'user2__', :email => 'user2__@example.com')
    end
  end
  
  test "creating 2 users should result in each having 1 node apiece" do
    u1 = create_user(:login => 'user1__', :email => 'user1__@example.com')
    u2 = create_user(:login => 'user2__', :email => 'user2__@example.com')
    
    assert_equal 1, Node.all.select{|n| n.root.pile.owner == u1 }.count
    assert_equal 1, Node.all.select{|n| n.root.pile.owner == u2 }.count
  end
  
  
protected
  
  def create_user(options = {})
    invite = Invite.new(:recipient_email => '')
    invite.save_with_validation(false)
    
    record = User.new({
      :login => 'quiree',
      :email => 'quire@example.com',
      :password => 'quire69',
      :password_confirmation => 'quire69',
      :invite_token => invite.token
    }.merge(options))
    record.save # normal save to create piles
    record
  end
  
end
