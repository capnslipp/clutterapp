require 'spec_helper'

describe "/piles/edit.html.erb" do
  include PilesHelper
  dataset :users
  
  
  before(:each) do
    @user = users(:slippy_douglas)
    assigns[:pile] = @pile = @user.root_pile
  end
  
  it "renders the edit pile form" do
    assigns[:owner] = @owner = @user
    
    render
    
    response.should have_tag("form[action=?][method=post]", user_pile_path(:user_id => @user, :id => @pile)) do
    end
  end
end
