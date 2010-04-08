require 'spec_helper'

describe LinkPropsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/link_props" }.should route_to(:controller => "link_props", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/link_props/new" }.should route_to(:controller => "link_props", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/link_props/1" }.should route_to(:controller => "link_props", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/link_props/1/edit" }.should route_to(:controller => "link_props", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/link_props" }.should route_to(:controller => "link_props", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/link_props/1" }.should route_to(:controller => "link_props", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/link_props/1" }.should route_to(:controller => "link_props", :action => "destroy", :id => "1") 
    end
  end
end
