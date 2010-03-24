require 'spec_helper'

describe PublicShare do
  dataset :users, :piles, :nodes
  
  
  it "should create a new instance given valid attributes" do
    @share = described_class.create! :pile => piles(:plans)
  end
  
  it "should not create a new instance given invalid attributes" do
    @share = described_class.create :pile => nil
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
    
    @share = described_class.create :pile_id => 0
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
  end
  
  it "should not allow more than one per Pile" do
    # first should succeed
    @share = described_class.create! :pile => piles(:plans)
    
    # second should fail
    @share = described_class.create :pile => piles(:plans)
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
  end
  
end
