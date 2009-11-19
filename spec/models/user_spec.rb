require 'spec_helper'

describe User do
  
  before(:each) do
    activate_authlogic
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
  
  it "should not require invite" do
    u = Factory.create(:user, :invite => nil)
    u.errors.on(:invite).should be_nil
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
