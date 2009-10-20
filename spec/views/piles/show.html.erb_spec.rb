require 'spec_helper'

describe "/piles/show.html.erb" do
  include PilesHelper
  
  
  before(:each) do
    @user = Factory.create(:user)
    assigns[:pile] = @pile = Factory.create(:pile, :owner => @user)
    assigns[:base_node] = @pile.root_node
  end
  
  
  it "renders attributes in <p>" do
    render
  end
  
end
