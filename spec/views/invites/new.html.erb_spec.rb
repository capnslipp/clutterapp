require 'spec_helper'

describe "/invites/new.html.erb" do
  include InvitesHelper

  before(:each) do
    assigns[:invite] = stub_model(Invite,
      :new_record? => true
    )
  end

  it "renders new invite form" do
    render

    response.should have_tag("form[action=?][method=post]", invites_path) do
    end
  end
end
