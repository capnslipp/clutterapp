require 'spec_helper'

describe Share do
  dataset :users
  
  
  before(:each) do
    @user1 = users(:a_user)
    @user2 = users(:a_user)
    @pile1 = @user1.default_pile
    @pile2 = @user2.default_pile
  end

  it "should create a new instance given valid attributes" do
    @share = Share.new(:user_id => @user1.id, :shared_pile_id => @user1.default_pile.id)
    @share.should be_valid
  end
  
  it "should not create a new instance given invalid attributes" do
    @share = Share.new(:user_id => @user1.id, :shared_pile_id => @user1.id)
    @share.should_not be_valid
  end
  
end
