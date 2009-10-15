require 'spec_helper'

describe Node do
  
  before(:each) do
    @user = Factory.create(:user)
    @pile = @user.default_pile
    @node = @pile.root_node
  end
  
end
