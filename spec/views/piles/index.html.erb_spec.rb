require 'spec_helper'

describe "/piles/index.html.erb" do
  include PilesHelper
  dataset :users, :piles, :nodes
  
  it "renders a list of piles" do
    assigns[:user] = @user = users(:slippy_douglas)
    assigns[:root_pile] = @root_pile = piles(:slippys)
    
    render
  end
end
