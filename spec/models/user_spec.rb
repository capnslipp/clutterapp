require 'spec_helper'

describe User do
  
  before(:each) do
    activate_authlogic
    @user = Factory.create(:user)
  end
  
  it "should be valid" do
    @user.should be_valid
  end
  
  it "should be able to add 1 user" do
    @user.followees << Factory.create(:user)
    @user.followees.count.should == 1
  end
  
  it "should be able to add 10 users" do
    1.upto(10) do
      @user.followees << Factory.create(:user)
    end
    @user.followees.count.should == 10
  end
  
  it "should not let followees have access by default"
  
  it "should be created" do
    assert_difference 'User.count' do
      u = Factory.create(:user)
      u.new_record?.should == false
    end
  end
  
  it "should require login" do
    assert_no_difference 'User.count' do
      u = User.create( Factory.attributes_for(:user).merge!(:login => nil) )
      u.errors.on(:login).should_not be_nil
    end
  end
  
  it "should require password" do
    assert_no_difference 'User.count' do
      u = User.create( Factory.attributes_for(:user).merge!(:password => nil) )
      u.errors.on(:password).should_not be_nil
    end
  end
  
  it "should require password confirmation" do
    assert_no_difference 'User.count' do
      u = User.create( Factory.attributes_for(:user).merge!(:password_confirmation => nil) )
      u.errors.on(:password_confirmation).should_not be_nil
    end
  end
  
  it "should require email" do
    assert_no_difference 'User.count' do
      u = User.create( Factory.attributes_for(:user).merge!(:email => nil) )
      u.errors.on(:email).should_not be_nil
    end
  end
  
  
  it "should reset password" do
    u = Factory.create(:user, :login => 'original_username', :password => 'or1ginalP4ssword')

    u.update_attributes(:password => 'n3wP4ssword', :password_confirmation => 'n3wP4ssword')
    #User.authenticate('original_username', 'n3wP4ssword').should == u
  end
  
  it "should not rehash password" do
    u = Factory.create(:user, :login => 'original_username', :password => 'or1ginalp4ssword')
    u.update_attributes(:login => 'new_username')
    u.password.should == 'or1ginalp4ssword'
    # User.('new_username', 'or1ginalp4ssword').should == u
  end
  
  
  it "should authenticate user" #do
  #  u = Factory.create(:user, :login => 'alpha1', :password => 's3cret')
  #  controller.session["user_credentials"].should == nil
  #  UserSession.create(u).should == true
  #  controller.session["user_credentials"].should == u.persistence_token
  #  # User.authenticate('alpha1', 's3cret').should == u
  #end
  
  it "shouldn't authenticate user with incorrect password" #do
  #  u = Factory.create(:user, :login => 'alpha1', :password => 's3cret')
  #  controller.session["user_credentials"].should == false
  #  UserSession.create(Factory.attributes_for(:user).merge!(:password => "inc0rrect")).should == false
  #  # UserSession.new(:login => 'alpha1', :password => 'inc0rrect').valid? == false
  #end
  
  
  it "should set remember token" do
    session = UserSession.create(@user, :remember_me => true)
    UserSession.remember_me.should_not be_nil
  end
  
  it "should unset remember token" do
    session = UserSession.create(@user, :remember_me => true)
    UserSession.remember_me.should_not be_nil
    UserSession.remember_me = false
    UserSession.remember_me.should == false
  end
  
  it "should remember me for one week" #do
  #  session = UserSession.create(@user, :remember_me => true)
  #  before = 1.week.from_now.utc
  #  session.remember_me_for 1.week
  #  after = 1.week.from_now.utc
  #  session.remember_me.should_not be_nil
  #  session.
  #  assert @user.remember_token_expires_at.between?(before, after)
  #end
  
  it "should remember me until one week" #do
  #  time = 1.week.from_now.utc
  #  @user.remember_me_until time
  #  assert_not_nil @user.remember_token
  #  assert_not_nil @user.remember_token_expires_at
  #  assert_equal @user.remember_token_expires_at, time
  #end
  
  it "should remember me default two weeks" #do
  #  before = 2.weeks.from_now.utc
  #  @user.remember_me
  #  after = 2.weeks.from_now.utc
  #  assert_not_nil @user.remember_token
  #  assert_not_nil @user.remember_token_expires_at
  #  assert @user.remember_token_expires_at.between?(before, after)
  #end
  
  
  it "should create 2 Piles, when creating 2 Users" do
    assert_difference 'Pile.count', +2 do
      u1, u2 = 2.times { Factory.create(:user) }
    end
  end
  
  it "should create 1 Pile for each new user, when creating 2 Users" do
    u1, u2 = Factory.create(:user), Factory.create(:user)
    
    u1.piles.count.should == 1
    Pile.find_all_by_owner_id(u1.id).count.should == 1
    Pile.find_all_by_owner_id(u2.id).count.should == 1
  end
  
  it "should create 2 Nodes, when creating 2 Users" do
    assert_difference 'Node.count', +2 do
      u1, u2 = 2.times { Factory.create(:user) }
    end
  end
  
  it "should create 1 Node for each new User, when creating 2 Users" do
    u1, u2 = Factory.create(:user), Factory.create(:user)
    
    Node.all.select {|n| n.root.pile.owner == u1 }.count.should == 1
    Node.all.select {|n| n.root.pile.owner == u2 }.count.should == 1
  end
  
end
