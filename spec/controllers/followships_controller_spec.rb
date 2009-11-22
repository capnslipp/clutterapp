require 'spec_helper'

describe FollowshipsController do
  before(:each) do
    activate_authlogic
    login
  end
  #Delete these examples and add some real ones
  it "should use FollowshipsController" do
    controller.should be_an_instance_of(FollowshipsController)
  end


  describe "GET 'create'" do
    it "should be successful" do
      get 'create'
      response.should be_success
    end
  end
  
  
  describe "DELETE 'destroy'" do
    it "should be successful" #do
    #  delete 'destroy'
    #  response.should be_success
    #end
  end
  
end
