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
      @user.add_followee(Factory.create(:user))
      @user.followees.count.should == 1
    end
    
    it "should be able to follow 1 user" do
      @user.follow(Factory.create(:user))
      @user.users.count.should == 1
    end
    
    it "should be able to follow 10 users" do
      1.upto(10) do
        @user.follow(Factory.create(:user))
      end
      @user.users.count.should == 10
    end
    
    it "should be able to add 10 followees" do
      1.upto(10) do
        @user.add_followee(Factory.create(:user))
      end
      @user.followees.count.should == 10
    end
    
    it "should let followees follow the user" do
      followee = Factory.create(:user)
      @user.add_followee(followee)
      followee.follow(@user)
      followee.users.count.should == 1
    end

    it "should let user access who it follows" do
      u1 = Factory.create(:user)
      u2 = Factory.create(:user)
      u1.add_followee(@user)
      u2.add_followee(@user)
      @user.follows.count.should == 2
    end
    
    it "should find unique users by who the user follows" do
      10.times do |f|
        Followship.create(:user_id => Factory.create(:user).id, :followee_id => @user.id)
        Followship.create(:user_id => Factory.create(:user).id, :followee_id => Factory.create(:user).id)
      end
      followships = User.find_follows(@user)
      followships.count.should == 10
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
