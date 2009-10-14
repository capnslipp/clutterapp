require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  #fixtures :users # using factory_girl now

  def test_should_create_user
    assert_difference 'User.count' do
      user = create_user()
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference 'User.count' do
      u = create_user(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  # @fix: These tests are breaking! Grab the latest authenticated_system or something.
  #def test_should_reset_password
  #  users(:one).update_attributes(:password => 'new password', :password_confirmation => 'new password')
  #  assert_equal users(:one), User.authenticate('quentin', 'new password')
  #end
  #
  #def test_should_not_rehash_password
  #  users(:one).update_attributes(:login => 'quentin2')
  #  assert_equal users(:one), User.authenticate('quentin2', 'monkey')
  #end

  def test_should_authenticate_user
    assert_equal Factory.create(:user, :login => 'alpha1', :password => 'secret'), User.authenticate('alpha1', 'monkey')
  end

  def test_should_set_remember_token
    users(:one).remember_me
    assert_not_nil users(:one).remember_token
    assert_not_nil users(:one).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:one).remember_me
    assert_not_nil users(:one).remember_token
    users(:one).forget_me
    assert_nil users(:one).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    users(:one).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:one).remember_token
    assert_not_nil users(:one).remember_token_expires_at
    assert users(:one).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    users(:one).remember_me_until time
    assert_not_nil users(:one).remember_token
    assert_not_nil users(:one).remember_token_expires_at
    assert_equal users(:one).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    users(:one).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:one).remember_token
    assert_not_nil users(:one).remember_token_expires_at
    assert users(:one).remember_token_expires_at.between?(before, after)
  end
  
  
  test "creating 2 users should result in 2 additional piles" do
    assert_difference 'Pile.count', +2 do
      u1 = create_user(:login => 'user1__', :email => 'user1__@example.com')
      u2 = create_user(:login => 'user2__', :email => 'user2__@example.com')
    end
  end
  
  test "creating 2 users should result in each having 1 pile apiece" do
    u1 = create_user(:login => 'user1__', :email => 'user1__@example.com')
    u2 = create_user(:login => 'user2__', :email => 'user2__@example.com')
    
    assert_equal 1, Pile.find_all_by_owner_id(u1.id).count
    assert_equal 1, Pile.find_all_by_owner_id(u2.id).count
  end
  
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
    record.save
    record
  end
end
