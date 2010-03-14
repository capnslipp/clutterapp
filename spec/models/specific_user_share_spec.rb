require 'spec_helper'

describe SpecificUserShare do
  dataset :users, :piles
  
  
  it "should create a new instance given valid attributes" do
    @share = SpecificUserShare.create! :pile => piles(:plans_to_rule_the_world), :sharee => users(:josh_vera)
  end
  
  it "should not create a new instance given invalid attributes" do
    @share = described_class.create :pile => nil, :sharee => users(:slippy_douglas)
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
    
    @share = described_class.create :pile_id => 0, :sharee => users(:slippy_douglas)
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
    
    @share = described_class.create :pile => piles(:plans_to_rule_the_world), :sharee => nil
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
    
    @share = described_class.create :pile => piles(:plans_to_rule_the_world), :sharee_id => 0
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
    
    @share = described_class.create :pile => nil, :sharee => nil
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
  end
  
  it "should not allow more than one per Pile" do
    # first should succeed
    @share = described_class.create! :pile => piles(:plans_to_rule_the_world), :sharee => users(:josh_vera)
    
    # second should fail
    @share = described_class.create :pile => piles(:plans_to_rule_the_world), :sharee => users(:josh_vera)
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
  end
  
  it "should not allow sharing with the owner" do
    @share = described_class.create :pile => piles(:plans_to_rule_the_world), :sharee => piles(:plans_to_rule_the_world).owner
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
  end
  
end
