require 'spec_helper'

describe Followship do
  dataset :users
  
  
  before(:each) do
    activate_authlogic
    @pile = users(:slippy_douglas).root_pile
  end
  
  describe "Finding followships" do
    it "should create a followship between a user and a followee" do
      followship = Followship.create(:user_id => users(:slippy_douglas).id, :followee_id => users(:slippy_douglas).id)
      followship.should be_valid
    end
  end
end
