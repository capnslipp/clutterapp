require 'spec_helper'

describe Node do
  dataset :users
  
  
  before(:each) do
    @user = users(:a_user)
    @pile = @user.default_pile
    @node = @pile.root_node
  end
  
end
