require 'spec_helper'

describe UserSession do
  dataset :users
  
  
  before(:each) do
    activate_authlogic
    @user = users(:slippy_douglas)
  end
  
  
  it "should set remember_me" do
    session = UserSession.create(@user, :remember_me => true)
    UserSession.remember_me.should_not be_nil
  end
  
  it "should unset remember_me" do
    session = UserSession.create(@user, :remember_me => true)
    UserSession.remember_me.should_not be_nil
    UserSession.remember_me = false
    UserSession.remember_me.should == false
  end
  
  it "should remember me for one week" do
    session = UserSession.create(@user, :remember_me => true)
    
    Authlogic::Session::Cookies.stub!(:remember_me_for).and_return(1.week)
    
    before = 1.week.from_now.utc
    session.remember_me = true
    
    after = 1.week.from_now.utc
    session.remember_me.should_not be_nil
    
    # @todo: find a way to check when it actually expires (roll time forward and check that it expired?)
  end
  
  it "should remember me until one week" do
    session = UserSession.create(@user, :remember_me => true)
    
    time = 1.week.from_now.utc
    
    Authlogic::Session::Cookies.stub!(:remember_me_until).and_return(time)
    
    session.remember_me.should_not be_nil
    
    # @todo: find a way to check when it actually expires (roll time forward and check that it expired?)
  end
  
  it "should remember me default two weeks" do
    session = UserSession.create(@user, :remember_me => true)
    
    before = 2.weeks.from_now.utc
    session.remember_me
    
    after = 2.weeks.from_now.utc
    session.remember_me.should_not be_nil
    
    # @todo: find a way to check when it actually expires (roll time forward and check that it expired?)
  end
  
end
