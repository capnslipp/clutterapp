require 'spec_helper'

describe "/piles/show.html.erb" do
  include PilesHelper
  dataset :users
  
  
  before(:each) do
    @user = users(:slippy_douglas)
    assigns[:pile] = @pile = @user.default_pile
    assigns[:base_node] = @pile.root_node
  end
  
  it "renders attributes in <p>" do
    assigns[:owner] = @owner = @user
    
    render
  end
end
