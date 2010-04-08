require 'spec_helper'

describe LinkProp do
  before(:each) do
    @valid_attributes = {
      :link => "value for link"
    }
  end

  it "should create a new instance given valid attributes" do
    LinkProp.create!(@valid_attributes)
  end
end
