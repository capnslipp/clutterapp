require 'spec_helper'

describe "/link_props/show.html.erb" do
  include LinkPropsHelper
  before(:each) do
    assigns[:link_prop] = @link_prop = stub_model(LinkProp,
      :link => "value for link"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ link/)
  end
end
