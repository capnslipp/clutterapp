require 'spec_helper'

describe "/link_props/edit.html.erb" do
  include LinkPropsHelper

  before(:each) do
    assigns[:link_prop] = @link_prop = stub_model(LinkProp,
      :new_record? => false,
      :link => "value for link"
    )
  end

  it "renders the edit link_prop form" do
    render

    response.should have_tag("form[action=#{link_prop_path(@link_prop)}][method=post]") do
      with_tag('input#link_prop_link[name=?]', "link_prop[link]")
    end
  end
end
