require 'spec_helper'

describe PublicShare do
  dataset :users, :piles
  
  
  it "should create a new instance given valid attributes" do
    @share = described_class.create! :pile => piles(:plans_to_rule_the_world)
  end
  
  it "should not create a new instance given invalid attributes" do
    @share = described_class.create :pile => nil
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
    
    @share = described_class.create :pile_id => 0
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
  end
  
  it "should not allow more than one per Pile" do
    # first should succeed
    @share = described_class.create! :pile => piles(:plans_to_rule_the_world)
    
    # second should fail
    @share = described_class.create :pile => piles(:plans_to_rule_the_world)
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
  end
  
end
