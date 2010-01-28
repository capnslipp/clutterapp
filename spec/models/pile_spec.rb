require 'spec_helper'

describe Pile do
  dataset :users
  
  
  it "should create 2 Nodes, when creating 2 Users" do
    u1_attributes = users(:a_user).destroy_to_attributes
    u2_attributes = users(:another_user).destroy_to_attributes
    
    assert_difference 'Node.count', +2 do
      User.create u1_attributes
      User.create u2_attributes
    end
  end
  
  it "should create 1 Node for each new Pile, when creating 2 Users" do
    u1_attributes = users(:a_user).destroy_to_attributes
    u2_attributes = users(:another_user).destroy_to_attributes
    
    u1 = User.create u1_attributes
    u2 = User.create u2_attributes
    
    Node.all.select {|n| n.root.pile.owner == u1 }.count.should == 1
    Node.all.select {|n| n.root.pile.owner == u2 }.count.should == 1
  end
  
end
