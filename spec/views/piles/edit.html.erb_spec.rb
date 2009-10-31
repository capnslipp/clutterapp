require 'spec_helper'

describe "/piles/edit.html.erb" do
  include PilesHelper
  
  
  before(:each) do
    @user = Factory.create(:user)
    assigns[:pile] = @pile = Factory.create(:pile, :owner => @user)
  end
  
  
  it "renders the edit pile form" do
    render
    
    response.should have_tag("form[action=#{pile_path(@pile)}][method=post]") do
    end
  end
  
end
