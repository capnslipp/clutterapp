require 'spec_helper'

describe User do
  dataset :users
  
  
  before(:each) do
    activate_authlogic
  end
    
  it "should be created" do
    user_attributes = users(:a_user).destroy_to_attributes
    
    assert_difference 'User.count' do
      u = User.create! user_attributes
      u.new_record?.should == false
    end
  end
  
  
  describe "login" do
    
    it "should require login" do
      user_attributes = users(:a_user).destroy_to_attributes
      
      assert_no_difference 'User.count' do
        u = User.create( user_attributes.merge!(:login => nil) )
        u.errors.on(:login).should_not be_nil
      end
    end
    
  end
  
  
  describe "password" do
    
    it "should require password" do
      user_attributes = users(:a_user).destroy_to_attributes
      
      assert_no_difference 'User.count' do
        u = User.create user_attributes.merge!(:password => nil)
        u.errors.on(:password).should_not be_nil
      end
    end
    
    it "should require password confirmation" do
      user_attributes = users(:a_user).destroy_to_attributes
      
      assert_no_difference 'User.count' do
        u = User.create user_attributes.merge!(:password_confirmation => nil)
        u.errors.on(:password_confirmation).should_not be_nil
      end
    end
    
    it "should reset password" do
      u = users(:a_user)
      
      u.update_attributes(:password => 'n3wP4ssword', :password_confirmation => 'n3wP4ssword')
      UserSession.create(:login => 'a_user', :password => 'n3wP4ssword').errors.count.should == 0
    end
    
    it "should not rehash password" do
      u = users(:a_user)
      u.update_attributes(:login => 'new_username')
      
      UserSession.create(:login => 'new_username', :password => 'secret').errors.count.should == 0
    end
    
  end
  
  
  describe "email" do
    
    it "should require email" do
      user_attributes = users(:a_user).destroy_to_attributes
      
      assert_no_difference 'User.count' do
        u = User.create user_attributes.merge!(:email => nil)
        u.errors.on(:email).should_not be_nil
      end
    end
    
  end
  
  
  describe "sharing" do
    
    it "should be able to share 1 pile with 1 followee" do
      users(:a_user).follow users(:another_user)
      users(:a_user).share_pile_with_user(
        users(:another_user),
        users(:a_user).default_pile
      )
      
      users(:another_user).authorized_piles.count.should == 1
      users(:a_user).shared_piles.count.should == 1
    end
    
    it "should be able to share 1 pile with 1 follower" do
      users(:another_user).follow users(:a_user)
      users(:a_user).share_pile_with_user(
        users(:another_user),
        users(:a_user).default_pile
      )
      
      users(:another_user).authorized_piles.count.should == 1
      users(:a_user).shared_piles.count.should == 1
    end
    
    it "should be able to share a pile publicly" do
      pending
      users(:a_user).share_pile_with_public users(:a_user).default_pile
    end
    
    it "should not let users access piles that aren't shared" do
      users(:a_user).authorized_piles << users(:another_user).default_pile
      users(:a_user).authorized_piles.count.should == 0
    end
    
    it "should have access to the sharees you share a pile with" do
      pending
      users(:a_user).share_pile_with_user(
        users(:another_user),
        users(:a_user).default_pile
      )
      
      users(:a_user).sharees.count.should == 1
      users(:a_user).sharees.first.should == users(:another_user)
    end
    
    it "should be able to share pile with followers" do
      pending
      users(:a_user).share_pile_with_followers users(:a_user).default_pile
      
      users(:a_user).followers.each do |follower|
        follower.authorized_piles.first.should == users(:a_user).default_pile
      end
    end
    
  end
  
  
  
  describe "followees" do
    it "should be able to add 1 followee" do
      users(:a_user).follow users(:another_user)
      
      users(:a_user).followees.count.should == 1
    end
    
    # For this test, the @user follows @user2
    # So how should @user2 have access to @user?
    # I'm thinking the user_id in Followship should be akin to 
    # follower_id. and @user.followers should be 1?
    it "should be able to follow 1 user" do
      users(:a_user).follow users(:another_user)
      
      users(:a_user).followees.count.should == 1
    end
    
    it "should be able to follow 10 Users and have a followees count of 10" do
      pending
      
      1.upto(10) do
        users(:a_user).follow(User.create(
          …
        ))
      end
      
      users(:a_user).followees.count.should == 10
    end
    
    it "should be able to follow 10 Users and each of them should be followed by it" do
      pending
      
      followees = []
      
      1.upto(10) do
        followees << followee_user = User.create(
          …
        )
        users(:a_user).follow followee_user
      end
      
      followees.each do |fu|
        fu.should be_followed_by(users(:a_user))
      end
    end
    
    it "should be able to have 10 Users follow it and have a followers count of 10" do
      pending
      
      1.upto(10) do
        User.create(
          …
        ).follow users(:a_user)
      end
      
      users(:a_user).followers.count.should == 10
    end
    
    it "should be able to have 10 Users follow it and each of them should be following it" do
      pending
      
      followers = []
      
      1.upto(10) do
        followers << follower_user = User.create(
          …
        )
        follower_user.follow users(:a_user)
      end
      
      followers.each do |fu|
        fu.should be_following(users(:a_user))
      end
    end
    
    it "should let followees follow the user" do
      users(:a_user).follow users(:another_user)
      
      users(:another_user).followers.count.should == 1
    end
    
    it "should let user access who follows it" do
      pending
      
      u1 = users(:a_user)
      u2 = users(:a_user)
      u1.follow(@user)
      u2.follow(@user)
      
      @user.followers.count.should == 2
    end
    
    it "should let user access who it follows" do
      pending
      
      u1 = users(:a_user)
      u2 = users(:a_user)
      @user.follow(u1)
      @user.follow(u2)
      
      @user.followees.count.should == 2
    end
    
    it "should find unique users by who the user follows" do
      pending
      
      10.times do |f|
        Followship.create(:user_id => users(:a_user).id, :followee_id => @user.id)
        Followship.create(:user_id => users(:a_user).id, :followee_id => users(:a_user).id)
      end
      
      User.followers_of(@user).count.should == 10
    end
    
    describe "when both users are following each other" do
      before(:each) do
        users(:a_user).follow users(:another_user)
        users(:another_user).follow users(:a_user)
      end  
      
      it "should be mutual friends" do
        users(:a_user).should be_friends_with(users(:another_user))
        users(:another_user).should be_friends_with(users(:a_user))
      end
      
      it "should be included in each other's friends list" do
        users(:a_user).friends.should be_include(users(:another_user))
        users(:another_user).friends.should be_include(users(:a_user))
      end
    end
    
  end
  
  
  describe "invite" do
    
    #it "should accept invite" do
    #  u = Factory.create(:user, :invite => Factory.create(:invite))
    #  
    #  u.errors.on(:invite).should be_nil
    #end
    #
    #it "should NOT require invite" do
    #  u = Factory.create(:user, :invite => nil)
    #  
    #  u.errors.on(:invite).should be_nil
    #end
    #
    #it "be able to create multiple users without invites" do
    #  u1, u2 = (1..2).to_a.collect { Factory.create(:user, :invite => nil) }
    #  
    #  [u1, u2].each { |u| u.errors.on(:invite).should be_nil }
    #end
    #
    #
    #it "should give back the invite's token if it has an invite" do
    #  i = Factory.create(:invite)
    #  u = Factory.create(:user, :invite => i)
    #  
    #  u.invite_token.should == i.token
    #end
    #
    #it "should give back nil if it doesn't have an invite" do
    #  u = Factory.create(:user, :invite => nil)
    #  
    #  u.invite_token.should be_nil
    #end
    #
    #it "should find and set the correct invite, given it's token" do
    #  i = Factory.create(:invite)
    #  u = Factory.create(:user, :invite => nil)
    #  
    #  u.invite_token = i.token
    #  
    #  u.invite.should == i
    #end
    
    it "should have infinite invites_remaining, given invite_limit of nil" do
      u = users(:a_user)
      u.invite_limit = nil
      
      u.invites_remaining.should be_infinite
    end
    
    
  end
  
  
  it "should create 2 Piles, when creating 2 Users" do
    @u1_attributes = users(:a_user).destroy_to_attributes
    @u2_attributes = users(:another_user).destroy_to_attributes
    
    assert_difference 'Pile.count', +2 do
      u1 = User.create! @u1_attributes
      u2 = User.create! @u2_attributes
    end
  end
  
  it "should create 1 Pile for each new user, when creating 2 Users" do
    @u1_attributes = users(:a_user).destroy_to_attributes
    @u2_attributes = users(:another_user).destroy_to_attributes
    
    u1 = User.create! @u1_attributes
    u2 = User.create! @u2_attributes
    
    u1.piles.count.should == 1
    u2.piles.count.should == 1
    Pile.find_all_by_owner_id(u1.id).count.should == 1
    Pile.find_all_by_owner_id(u2.id).count.should == 1
  end
  
  it "should create 2 Nodes, when creating 2 Users" do
    @u1_attributes = users(:a_user).destroy_to_attributes
    @u2_attributes = users(:another_user).destroy_to_attributes
    
    assert_difference 'Node.count', +2 do
      u1 = User.create! @u1_attributes
      u2 = User.create! @u2_attributes
    end
  end
  
  it "should create 1 Node for each new User, when creating 2 Users" do
    u1, u2 = users(:a_user), users(:a_user)
    
    Node.all.select {|n| n.root.pile.owner == u1 }.count.should == 1
    Node.all.select {|n| n.root.pile.owner == u2 }.count.should == 1
  end
  
end
