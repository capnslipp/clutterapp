require 'spec_helper'

describe "/piles/index.html.erb" do
  include PilesHelper
  dataset :users
  
  
  before(:each) do
    assigns[:pile_owner] = @user = users(:slippy_douglas)
    
    assigns[:piles] = [
      @user.default_pile,
      @user.default_pile
    ]
  end

  it "renders a list of piles" do
    assigns[:owner] = @owner = @user
    
    render
  end
end
