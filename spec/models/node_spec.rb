require 'spec_helper'

describe Node do
  dataset :users, :piles, :nodes
  
  
  before(:each) do
    @user = users(:slippy_douglas)
    @pile = @user.root_pile
    @node = @pile.root_node
  end
  
end
