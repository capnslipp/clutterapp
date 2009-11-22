require 'spec_helper'

describe User do
  
  before(:each) do
    activate_authlogic
    
    @user = Factory.create(:user)
  end
    
  it "should be created" do
    assert_difference 'User.count' do
      u = Factory.create(:user)
      u.new_record?.should == false
    end
  end
  
  
  describe "login" do
    
    it "should require login" do
      assert_no_difference 'User.count' do
        u = User.create( Factory.attributes_for(:user).merge!(:login => nil) )
        u.errors.on(:login).should_not be_nil
      end
    end
    
  end
  
  
  describe "password" do
    
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
    
  end
  
  
  describe "email" do
    
    it "should require email" do
      assert_no_difference 'User.count' do
        u = User.create( Factory.attributes_for(:user).merge!(:email => nil) )
        u.errors.on(:email).should_not be_nil
      end
    end
    
  end
  
  
  describe "followees" do
    it "should be able to add 1 followee" do
      @user.follow(Factory.create(:user))
      @user.followees.count.should == 1
    end
    
    #For this test, the @user follows @user2
    #So how should @user2 have access to @user?
    #I'm thinking the user_id in Followship should be akin to 
    #follower_id. and @user.followers should be 1?
    it "should be able to follow 1 user" do
      @user2 = Factory.create(:user)
      @user.follow(@user2)
      @user.followees.count.should == 1
    end
    
    it "should be able to follow 10 Users and have a followees count of 10" do
      1.upto(10) do
        @user.follow(Factory.create(:user))
      end
      @user.followees.count.should == 10
    end
    
    it "should be able to follow 10 Users and each of them should be followed by it" do
      @followees = []
      
      1.upto(10) do
        @followees << followee_user = Factory.create(:user)
        @user.follow(followee_user)
      end
      
      @followees.each do |fu|
        fu.should be_followed_by(@user)
      end
    end
    
    it "should be able to have 10 Users follow it and have a followers count of 10" do
      1.upto(10) do
        Factory.create(:user).follow(@user)
      end
      
      @user.followers.count.should == 10
    end
    
    it "should be able to have 10 Users follow it and each of them should be following it" do
      @followers = []
      
      1.upto(10) do
        @followers << follower_user = Factory.create(:user)
        follower_user.follow(@user)
      end
      
      @followers.each do |fu|
        fu.should be_following(@user)
      end
    end
    
    it "should let followees follow the user" do
      followee_user = Factory.create(:user)
      @user.follow(followee_user)
      followee_user.followers.count.should == 1
    end

    it "should let user access who it follows" do
      u1 = Factory.create(:user)
      u2 = Factory.create(:user)
      u1.follow(@user)
      u2.follow(@user)
      @user.followers.count.should == 2
    end
    
    it "should find unique users by who the user follows" do
      10.times do |f|
        Followship.create(:user_id => Factory.create(:user).id, :followee_id => @user.id)
        Followship.create(:user_id => Factory.create(:user).id, :followee_id => Factory.create(:user).id)
      end
      followships = User.followers_of(@user)
      followships.count.should == 10
    end
    
    it "should be mutual friends when both users are following each other" do
      another_user = Factory.create(:user)
      @user.follow(another_user)
      another_user.follow(@user)
      
      @user.should be_friends_with(another_user)
      another_user.should be_friends_with(@user)
    end
    
    it "should be included in each other's friends list when both users are following each other" do
      another_user = Factory.create(:user)
      @user.follow(another_user)
      another_user.follow(@user)
      
      @user.friends.should be_include(another_user)
      another_user.friends.should be_include(@user)
    end
    
  end
  
  
  describe "invite" do
    
    it "should accept invite" do
      u = Factory.create(:user, :invite => Factory.create(:invite))
      
      u.errors.on(:invite).should be_nil
    end
    
    it "should NOT require invite" do
      u = Factory.create(:user, :invite => nil)
      
      u.errors.on(:invite).should be_nil
    end
    
    it "be able to create multiple users without invites" do
      u1, u2 = (1..2).to_a.collect { Factory.create(:user, :invite => nil) }
      
      [u1, u2].each { |u| u.errors.on(:invite).should be_nil }
    end
    
  end
  
  
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
  
  
  it "should give back the invite's token if it has an invite" do
    i = Factory.create(:invite)
    u = Factory.create(:user, :invite => i)
    
    u.invite_token.should == i.token
  end
  
  it "should give back nil if it doesn't have an invite" do
    u = Factory.create(:user, :invite => nil)
    
    u.invite_token.should be_nil
  end
  
  it "should find and set the correct invite, given it's token" do
    i = Factory.create(:invite)
    u = Factory.create(:user, :invite => nil)
    
    u.invite_token = i.token
    
    u.invite.should == i
  end
  
  
  it "should have infinite invites_remaining, given invite_limit of nil" do
    u = Factory.create(:user)
    u.invite_limit = nil
    
    u.invites_remaining.should be_infinite
  end
  
  
  it "should raise exception on create_default_pile!, given it already having Pile(s)" do
    u = Factory.create(:user)
    u.piles.create(Factory.attributes_for(:pile))
    
    u.piles.count.should == 2
    
    Proc.new {
      u.send(:create_default_pile!)
    }.should raise_error
  end
  
  
  it "should not raise exception on create_default_pile!, given it having no Piles" do
    u = Factory.create(:user)
    u.stub!(:piles).and_return([])
    
    u.piles.count.should == 0
    
    Proc.new {
      u.send(:create_default_pile!)
    }.should_not raise_error
  end
  
  
end
