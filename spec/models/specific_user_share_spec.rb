require 'spec_helper'

describe SpecificUserShare do
  dataset :users, :piles
  
  
  it "should create a new instance given valid attributes" do
    @share = described_class.create! :pile => piles(:plans), :sharee => users(:josh_vera)
  end
  
  it "should not create a new instance given invalid attributes" do
    @share = described_class.create :pile => nil, :sharee => users(:slippy_douglas)
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
    
    @share = described_class.create :pile_id => 0, :sharee => users(:slippy_douglas)
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
    
    @share = described_class.create :pile => piles(:plans), :sharee => nil
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
    
    @share = described_class.create :pile => piles(:plans), :sharee_id => 0
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
    
    @share = described_class.create :pile => nil, :sharee => nil
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
  end
  
  it "should not allow more than one per Pile" do
    # first should succeed
    @share = described_class.create! :pile => piles(:plans), :sharee => users(:josh_vera)
    
    # second should fail
    @share = described_class.create :pile => piles(:plans), :sharee => users(:josh_vera)
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
  end
  
  it "should not allow sharing with the owner" do
    @share = described_class.create :pile => piles(:plans), :sharee => piles(:plans).owner
    lambda { @share.save! }.should raise_error(ActiveRecord::ActiveRecordError)
  end
  
end
