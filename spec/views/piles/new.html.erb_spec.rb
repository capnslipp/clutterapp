require 'spec_helper'

describe "/piles/new.html.erb" do
  include PilesHelper
  
  
  before(:each) do
    @user = Factory.create(:user)
    assigns[:pile] = @pile = Factory.create(:pile, :owner => @user)
  end
  
  
  it "renders new pile form" do
    render
    
    response.should have_tag("form[action=?][method=post]", user_piles_path(:user_id => @user)) do
    end
  end
  
end
