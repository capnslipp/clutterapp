require 'spec_helper'

describe User do
  dataset :users, :piles
  
  
  before(:each) do
    activate_authlogic
  end
    
  it "should be created" do
    user_attributes = users(:slippy_douglas).destroy_to_attributes
    
    assert_difference 'User.count' do
      u = User.create! user_attributes
      u.new_record?.should == false
    end
  end
  
  
  describe "login" do
    
    it "should require login" do
      user_attributes = users(:slippy_douglas).destroy_to_attributes
      
      assert_no_difference 'User.count' do
        u = User.create( user_attributes.merge!(:login => nil) )
        u.errors.on(:login).should_not be_nil
      end
    end
    
  end
  
  
  describe "password" do
    
    it "should require password" do
      user_attributes = users(:slippy_douglas).destroy_to_attributes
      
      assert_no_difference 'User.count' do
        u = User.create user_attributes.merge!(:password => nil)
        u.errors.on(:password).should_not be_nil
      end
    end
    
    it "should require password confirmation" do
      user_attributes = users(:slippy_douglas).destroy_to_attributes
      
      assert_no_difference 'User.count' do
        u = User.create user_attributes.merge!(:password_confirmation => nil)
        u.errors.on(:password_confirmation).should_not be_nil
      end
    end
    
    it "should reset password" do
      u = users(:slippy_douglas)
      
      u.update_attributes(:password => 'n3wP4ssword', :password_confirmation => 'n3wP4ssword')
      UserSession.create(:login => 'slippy_douglas', :password => 'n3wP4ssword').errors.count.should == 0
    end
    
    it "should not rehash password" do
      u = users(:slippy_douglas)
      u.update_attributes(:login => 'new_username')
      
      UserSession.create(:login => 'new_username', :password => 'secret').errors.count.should == 0
    end
    
  end
  
  
  describe "email" do
    
    it "should require email" do
      user_attributes = users(:slippy_douglas).destroy_to_attributes
      
      assert_no_difference 'User.count' do
        u = User.create user_attributes.merge!(:email => nil)
        u.errors.on(:email).should_not be_nil
      end
    end
    
  end
  
  
  describe "sharing" do
    
    it "should be able to share a pile publicly" do
      users(:slippy_douglas).share_pile_with_public users(:slippy_douglas).root_pile
    end
    
    it "should not let users access piles that aren't shared" do
      users(:slippy_douglas).authorized_piles << users(:josh_vera).root_pile
      users(:slippy_douglas).authorized_piles.count.should == 0
    end
    
    it "should have access to the sharees you share a pile with" do
      users(:slippy_douglas).share_pile_with_user(
        users(:josh_vera),
        users(:slippy_douglas).root_pile
      )
      
      users(:slippy_douglas).sharees.count.should == 1
      users(:slippy_douglas).sharees.first.should == users(:josh_vera)
    end
    
    it "should have access to people sharing with you" do
      users(:slippy_douglas).share_pile_with_user(users(:josh_vera), piles(:plans_to_rule_the_world))
      users(:josh_vera).sharers.count.should == 1
      users(:josh_vera).sharers.first.should == users(:slippy_douglas)
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
      u = users(:slippy_douglas)
      u.invite_limit = nil
      
      u.invites_remaining.should be_infinite
    end
    
    
  end
  
  
  it "should create 2 Piles, when creating 2 Users" do
    @u1_attributes = users(:slippy_douglas).destroy_to_attributes
    @u2_attributes = users(:josh_vera).destroy_to_attributes
    
    assert_difference 'Pile.count', +2 do
      u1 = User.create! @u1_attributes
      u2 = User.create! @u2_attributes
    end
  end
  
  it "should create 1 Pile for each new user, when creating 2 Users" do
    @u1_attributes = users(:slippy_douglas).destroy_to_attributes
    @u2_attributes = users(:josh_vera).destroy_to_attributes
    
    u1 = User.create! @u1_attributes
    u2 = User.create! @u2_attributes
    
    u1.piles.count.should == 1
    u2.piles.count.should == 1
    Pile.find_all_by_owner_id(u1.id).count.should == 1
    Pile.find_all_by_owner_id(u2.id).count.should == 1
  end
  
  it "should create 2 Nodes, when creating 2 Users" do
    @u1_attributes = users(:slippy_douglas).destroy_to_attributes
    @u2_attributes = users(:josh_vera).destroy_to_attributes
    
    assert_difference 'Node.count', +2 do
      u1 = User.create! @u1_attributes
      u2 = User.create! @u2_attributes
    end
  end
  
  it "should create 1 Node for each new User, when creating 2 Users" do
    @u1_attributes = users(:slippy_douglas).destroy_to_attributes
    @u2_attributes = users(:josh_vera).destroy_to_attributes
    
    u1 = User.create! @u1_attributes
    u2 = User.create! @u2_attributes
    
    Node.all.select {|n| n.root.pile.owner == u1 }.count.should == 1
    Node.all.select {|n| n.root.pile.owner == u2 }.count.should == 1
  end
  
end
