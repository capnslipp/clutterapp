require 'spec_helper'

describe "/link_props/new.html.erb" do
  include LinkPropsHelper

  before(:each) do
    assigns[:link_prop] = stub_model(LinkProp,
      :new_record? => true,
      :link => "value for link"
    )
  end

  it "renders new link_prop form" do
    render

    response.should have_tag("form[action=?][method=post]", link_props_path) do
      with_tag("input#link_prop_link[name=?]", "link_prop[link]")
    end
  end
end
