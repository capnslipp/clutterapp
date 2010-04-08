require 'spec_helper'

describe "/link_props/index.html.erb" do
  include LinkPropsHelper

  before(:each) do
    assigns[:link_props] = [
      stub_model(LinkProp,
        :link => "value for link"
      ),
      stub_model(LinkProp,
        :link => "value for link"
      )
    ]
  end

  it "renders a list of link_props" do
    render
    response.should have_tag("tr>td", "value for link".to_s, 2)
  end
end
