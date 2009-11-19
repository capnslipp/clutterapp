require 'spec_helper'

describe Followship do
  
  before(:each) do
    @user = Factory.create(:user)
    @pile = @user.default_pile
  end
  
  it "should be able to add 1 followees" do
    @user.add_followee(Factory.create(:user))
    @user.followees.count.should == 1
  end

  it "should be able to add 10 followees" do
    1.upto(10) do
      @user.add_followee(Factory.create(:user))
    end
    @user.followees.count.should == 10
  end

  it "should not let followees have access by default" do
    followee = Factory.create(:user)
    @user.add_followee(Factory.create(:user))
    followee.users.count.should == 0
  end
  
  it "should let followees access shared piles" do
    charles = Factory.create(:user)
    charles.share_pile_with_user(@pile, @user)
    @user.add_followee(Factory.create(:user))
  
  end
end

