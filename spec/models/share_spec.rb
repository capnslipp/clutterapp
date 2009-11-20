require 'spec_helper'

describe Share do
  before(:each) do
    @user1 = Factory.create(:user)
    @user2 = Factory.create(:user)
    @pile1 = @user1.default_pile
    @pile2 = @user2.default_pile
  end

  it "should create a new instance given valid attributes" do
    
  end
end
