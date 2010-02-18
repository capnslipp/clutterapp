require 'spec_helper'

describe FollowshipsController do
  dataset :users
  
  
  before(:each) do
    activate_authlogic
    #@followship = Factory.create(:followship)
  end
  #Delete these examples and add some real ones
  # it "should use FollowshipsController" do
  #   controller.should be_an_instance_of(FollowshipsController)
  # end
  # 
  # describe "new followship with valid followships" do
  #   it "should create the new followship" # do
  #   #       @user = users(:slippy_douglas) 
  #   #       post :toggle_follow, :followship => @followship
  #   #     end
  # end
  # 
  # describe "POST 'create'" do
  #   it "should be successful" # do
  #   #                   post 'create'
  #   #                   response.should be_success
  #   #                 end
  # end
  # 
  # 
  # describe "DELETE 'destroy'" do
  #   it "should be successful" # do
  #   #          delete 'destroy'
  #   #          response.should be_success
  #   #         end
  # end
  # 
end
