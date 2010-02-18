require 'spec_helper'

describe "/piles/new.html.erb" do
  include PilesHelper
  dataset :users
  
  
  before(:each) do
    @user = users(:slippy_douglas)
    assigns[:pile] = @pile = @user.default_pile
  end
  
  it "renders new pile form" do
    assigns[:owner] = @owner = @user
    
    render
    
    response.should have_tag("form[action=?][method=post]", user_piles_path(:user_id => @user)) do
    end
  end
end
