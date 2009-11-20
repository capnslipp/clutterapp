require 'spec_helper'

describe FollowshipsController do

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

  describe "GET 'destroy'" do
    it "should be successful" do
      get 'destroy'
      response.should be_success
    end
  end
end
