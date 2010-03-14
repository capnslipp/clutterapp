require 'spec_helper'

describe SpecificUserShare do
  dataset :users, :piles
  
  
  it "should create a new instance given valid attributes" do
    @share = SpecificUserShare.create! :pile => piles(:plans_to_rule_the_world), :sharee => users(:josh_vera)
  end
  
  it "should not create a new instance given invalid attributes" do
    raising_lambdas = []
    
    lambda {
      @share = SpecificUserShare.create! :pile => nil, :sharee => users(:slippy_douglas)
    }.should raise_error(ActiveRecord::ActiveRecordError)
    
    lambda {
      @share = SpecificUserShare.create! :pile => piles(:plans_to_rule_the_world), :sharee => nil
    }.should raise_error(ActiveRecord::ActiveRecordError)
    
    lambda {
      @share = SpecificUserShare.create! :pile => nil, :sharee => nil
    }.should raise_error(ActiveRecord::ActiveRecordError)
    
    lambda {
      @share = SpecificUserShare.create! :pile => users(:slippy_douglas), :sharee => piles(:plans_to_rule_the_world) # swapped on purpose
    }.should raise_error(ActiveRecord::ActiveRecordError)
  end
  
end
