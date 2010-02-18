require 'spec_helper'

describe Node do
  dataset :users
  
  
  before(:each) do
    @user = users(:slippy_douglas)
    @pile = @user.default_pile
    @node = @pile.root_node
  end
  
end
