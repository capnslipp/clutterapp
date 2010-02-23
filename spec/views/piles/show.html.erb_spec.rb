require 'spec_helper'

describe "/piles/show.html.erb" do
  include PilesHelper
  dataset :users
  
  
  before(:each) do
    @user = users(:slippy_douglas)
    assigns[:piles] = @piles = @user.piles.master
    assigns[:pile] = @pile = @user.default_pile
  end
  
  it "renders attributes in <p>" do
    assigns[:owner] = @owner = @user
    
    render
  end
end
