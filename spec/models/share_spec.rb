require 'spec_helper'

describe Share do
  dataset :users
  
  
  before(:each) do
    @user1 = users(:slippy_douglas)
    @user2 = users(:slippy_douglas)
    @pile1 = @user1.root_pile
    @pile2 = @user2.root_pile
  end

  it "should create a new instance given valid attributes" do
    @share = Share.new(:user_id => @user1.id, :shared_pile_id => @user1.root_pile.id)
    @share.should be_valid
  end
  
  it "should not create a new instance given invalid attributes" do
    @share = Share.new(:user_id => @user1.id, :shared_pile_id => @user1.id)
    @share.should_not be_valid
  end
  
end
