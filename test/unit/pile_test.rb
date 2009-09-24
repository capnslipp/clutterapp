require 'test_helper'

class PileTest < ActiveSupport::TestCase
  
  test "2 users should have 2 piles total" do
    assert_difference 'Pile.count', +2 do
      u1 = create_user(:login => 'user1__', :email => 'user1__@example.com')
      u2 = create_user(:login => 'user2__', :email => 'user2__@example.com')
    end
  end
  
  test "2 users should each have 1 pile after creation" do
    u1 = create_user(:login => 'user1__', :email => 'user1__@example.com')
    u2 = create_user(:login => 'user2__', :email => 'user2__@example.com')
    
    assert_equal 1, Pile.find_all_by_owner_id(u1.id).count
    assert_equal 1, Pile.find_all_by_owner_id(u2.id).count
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
