require 'spec_helper'

describe "/piles/show.html.erb" do
  include PilesHelper
  dataset :users, :piles, :nodes
  
  
  before(:each) do
    @user = users(:slippy_douglas)
    assigns[:piles] = @piles = [@user.root_pile]
    assigns[:pile] = @pile = @user.root_pile
  end
  
  it "renders attributes in <p>" do
    assigns[:owner] = @owner = @user
    
    render
  end
end
