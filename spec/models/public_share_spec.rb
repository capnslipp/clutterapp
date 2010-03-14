require 'spec_helper'

describe PublicShare do
  dataset :users, :piles
  
  
  it "should create a new instance given valid attributes" do
    @share = PublicShare.create!(
      :pile => piles(:plans_to_rule_the_world)
    )
  end
  
  it "should not create a new instance given invalid attributes" do
    lambda {
      @share = PublicShare.create!(
        :pile => nil
      )
    }.should raise_error(ActiveRecord::ActiveRecordError)
    
    lambda {
      @share = PublicShare.create!(
        :pile => users(:slippy_douglas)
      )
    }.should raise_error(ActiveRecord::ActiveRecordError)
  end
  
end
