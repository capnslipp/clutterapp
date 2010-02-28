require 'spec_helper'

describe "/piles/index.html.erb" do
  include PilesHelper
  dataset :users
  
  
  before(:each) do
    assigns[:pile_owner] = @user = users(:slippy_douglas)
    
    assigns[:piles] = [
      @user.root_pile,
      @user.root_pile
    ]
  end

  it "renders a list of piles" do
    assigns[:owner] = @owner = @user
    
    render
  end
end
