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
    
    describe "a Pile publicly" do
      before(:each) do
        piles(:plans_to_rule_the_world).shares.destroy_all
        piles(:step_1_the_girl).shares.destroy_all
      end
      
      it "should be non-modifiable, by default" do
        piles(:plans_to_rule_the_world).share_publicly
        
        piles(:plans_to_rule_the_world).should be_shared
        piles(:plans_to_rule_the_world).should be_shared_publicly
        piles(:plans_to_rule_the_world).should be_accessible_publicly
        piles(:plans_to_rule_the_world).should_not be_modifiable_publicly
      end
      
      it "should be modifiable, when set" do
        piles(:plans_to_rule_the_world).share_publicly(:modifiable => true)
        
        piles(:plans_to_rule_the_world).should be_shared
        piles(:plans_to_rule_the_world).should be_shared_publicly
        piles(:plans_to_rule_the_world).should be_accessible_publicly
        piles(:plans_to_rule_the_world).should be_modifiable_publicly
      end
      
      it "should effectively share all sub-Piles (that don't have explicit sharing settings)" do
        piles(:plans_to_rule_the_world).share_publicly
        
        piles(:plans_to_rule_the_world).should be_accessible_publicly
        piles(:step_1_the_girl).should be_accessible_publicly
      end
      
      it "should not change the actual sharing settings on sub-Piles" do
        piles(:step_1_the_girl).should_not be_shared
        
        piles(:plans_to_rule_the_world).share_publicly
        
        piles(:step_1_the_girl).should_not be_shared
      end
    end
    
    describe "unsharing a publicly shared Pile" do
      before(:each) do
        piles(:plans_to_rule_the_world).shares.destroy_all
        piles(:step_1_the_girl).shares.destroy_all
        piles(:plans_to_rule_the_world).share_publicly
      end
      
      it "should work" do
        piles(:plans_to_rule_the_world).unshare_publicly
        
        piles(:plans_to_rule_the_world).should_not be_shared
        piles(:plans_to_rule_the_world).should_not be_shared_publicly
      end
      
      it "should effectively unshare all sub-Piles (that don't have explicit sharing settings)" do
        piles(:plans_to_rule_the_world).unshare_publicly
        
        piles(:plans_to_rule_the_world).should_not be_accessible_publicly
        piles(:step_1_the_girl).should_not be_accessible_publicly
      end
      
      it "should not change the actual sharing settings on sub-Piles" do
        piles(:step_1_the_girl).should_not be_shared
        
        piles(:plans_to_rule_the_world).unshare_with(users(:josh_vera))
        
        piles(:step_1_the_girl).should_not be_shared
      end
    end
    
    describe "a Pile with a specific User" do
      before(:each) do
        piles(:plans_to_rule_the_world).shares.destroy_all
        piles(:step_1_the_girl).shares.destroy_all
      end
      
      it "should be non-modifiable, by default" do
        piles(:plans_to_rule_the_world).share_with(users(:josh_vera))
        
        piles(:plans_to_rule_the_world).should be_shared
        piles(:plans_to_rule_the_world).should be_shared_with_specific_users
        piles(:plans_to_rule_the_world).should be_accessible_by_user(users(:josh_vera))
        piles(:plans_to_rule_the_world).should_not be_modifiable_by_user(users(:josh_vera))
      end
      
      it "should be modifiable, when set" do
        piles(:plans_to_rule_the_world).share_with(users(:josh_vera), :modifiable => true)
        
        piles(:plans_to_rule_the_world).should be_shared
        piles(:plans_to_rule_the_world).should be_shared_with_specific_users
        piles(:plans_to_rule_the_world).should be_accessible_by_user(users(:josh_vera))
        piles(:plans_to_rule_the_world).should be_modifiable_by_user(users(:josh_vera))
      end
      
      it "should effectively share all sub-Piles (that don't have explicit sharing settings)" do
        piles(:plans_to_rule_the_world).share_with(users(:josh_vera))

        piles(:plans_to_rule_the_world).should be_accessible_by_user(users(:josh_vera))
        piles(:step_1_the_girl).should be_accessible_by_user(users(:josh_vera))
      end
      
      it "should not change the actual sharing settings on sub-Piles" do
        piles(:step_1_the_girl).should_not be_shared
        
        piles(:plans_to_rule_the_world).share_with(users(:josh_vera))
        
        piles(:step_1_the_girl).should_not be_shared
      end
    end
    
    describe "unsharing a Pile shared with a specific User" do
      before(:each) do
        piles(:plans_to_rule_the_world).shares.destroy_all
        piles(:step_1_the_girl).shares.destroy_all
        piles(:plans_to_rule_the_world).share_with(users(:josh_vera))
      end
      
      it "should work" do
        piles(:plans_to_rule_the_world).unshare_with(users(:josh_vera))
        
        piles(:plans_to_rule_the_world).should_not be_shared
        piles(:plans_to_rule_the_world).should_not be_shared_with_specific_users
        piles(:plans_to_rule_the_world).should_not be_accessible_by_user(users(:josh_vera))
        piles(:plans_to_rule_the_world).should_not be_modifiable_by_user(users(:josh_vera))
      end
      
      it "should effectively unshare all sub-Piles (that don't have explicit sharing settings)" do
        piles(:plans_to_rule_the_world).unshare_with(users(:josh_vera))
        
        piles(:plans_to_rule_the_world).should_not be_accessible_by_user(users(:josh_vera))
        piles(:step_1_the_girl).should_not be_accessible_by_user(users(:josh_vera))
      end
      
      it "should not change the actual sharing settings on sub-Piles" do
        piles(:step_1_the_girl).should_not be_shared
        
        piles(:plans_to_rule_the_world).unshare_with(users(:josh_vera))
        
        piles(:step_1_the_girl).should_not be_shared
      end
    end
    
  end
  
end
