require 'spec_helper'

describe Pile do
  dataset :users, :piles
  
  
  it "should create 2 Nodes, when creating 2 Users" do
    u1_attributes = users(:slippy_douglas).destroy_to_attributes
    u2_attributes = users(:josh_vera).destroy_to_attributes
    
    assert_difference 'Node.count', +2 do
      User.create u1_attributes
      User.create u2_attributes
    end
  end
  
  it "should create 1 Node for each new Pile, when creating 2 Users" do
    u1_attributes = users(:slippy_douglas).destroy_to_attributes
    u2_attributes = users(:josh_vera).destroy_to_attributes
    
    u1 = User.create u1_attributes
    u2 = User.create u2_attributes
    
    Node.all.select {|n| n.root.pile.owner == u1 }.count.should == 1
    Node.all.select {|n| n.root.pile.owner == u2 }.count.should == 1
  end
  
  
  describe "sharing" do
    
    it "should be able to share a Pile publicly" do
      # precondition
      piles(:plans_to_rule_the_world).should_not be_shared_publicly
      
      # spec
      piles(:plans_to_rule_the_world).share_publicly
      piles(:plans_to_rule_the_world).should be_shared_publicly
    end
    
    it "should be able to unshare a publicly shared Pile" do
      # precondition
      piles(:plans_to_rule_the_world).share_publicly
      piles(:plans_to_rule_the_world).should be_shared_publicly
      
      # spec
      piles(:plans_to_rule_the_world).unshare_publicly
      piles(:plans_to_rule_the_world).should_not be_shared_publicly
    end
    
    it "should be able to share a Pile with a specific User" do
      # precondition
      piles(:plans_to_rule_the_world).should_not be_shared_with_specific_users
      
      # spec
      piles(:plans_to_rule_the_world).share_with users(:josh_vera)
      piles(:plans_to_rule_the_world).should be_shared_with_specific_users
    end
    
    it "should be able to unshare a Pile shared with a specific User" do
      # precondition
      piles(:plans_to_rule_the_world).share_with users(:josh_vera)
      piles(:plans_to_rule_the_world).should be_shared_with_specific_users
      
      # spec
      piles(:plans_to_rule_the_world).unshare_with users(:josh_vera)
      piles(:plans_to_rule_the_world).should_not be_shared_with_specific_users
    end
    
  end
  
end
