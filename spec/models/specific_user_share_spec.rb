require 'spec_helper'

describe SpecificUserShare do
  dataset :users, :piles
  
  
  it "should create a new instance given valid attributes" do
    @share = SpecificUserShare.create!(
      :pile => piles(:plans_to_rule_the_world),
      :sharee => users(:josh_vera)
    )
  end
  
  it "should not create a new instance given invalid attributes" do
    pending
    
    raising_lambdas = []
    
    raising_lambdas << lambda do
      @share = Share.create!(
        :user => users(:slippy_douglas),
        :pile => nil
      )
    end
    
    raising_lambdas << lambda do
      @share = Share.create!(
        :user => nil,
        :pile => piles(:plans_to_rule_the_world)
      )
    end
    
    raising_lambdas << lambda do
      @share = Share.create!(
        :user => nil,
        :pile => nil
      )
    end
    
    raising_lambdas << lambda do
      @share = Share.create!(
        :user => piles(:plans_to_rule_the_world),
        :pile => users(:slippy_douglas)
      )
    end
    
    raising_lambdas.each {|rl| rl.should raise_error(ActiveRecord::ActiveRecordError) }
  end
  
end
