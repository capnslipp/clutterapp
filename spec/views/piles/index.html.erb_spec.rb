require 'spec_helper'

describe "/piles/index.html.erb" do
  include PilesHelper
  
  
  before(:each) do
    assigns[:pile_owner] = @user = Factory.create(:user)
    
    assigns[:piles] = [
      Factory.create(:pile, :owner => @user),
      Factory.create(:pile, :owner => @user)
    ]
  end

  it "renders a list of piles" do
    assigns[:owner] = @owner = @user
    
    render
  end
end
