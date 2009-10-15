require 'spec_helper'

describe NodesController do
  describe "routing" do
    it "recognizes and generates #index" do
      u = Factory.create(:user)
      p = u.piles.first
      { :get => "#{u.login}/piles/#{p.id}/nodes" }.should route_to(:controller => 'nodes', :action => 'index', :user_id => u.to_param, :pile_id => p.id.to_s)
    end
    
    it "recognizes and generates #new" do
      u = Factory.create(:user)
      p = u.piles.first
      { :get => "#{u.login}/piles/#{p.id}/nodes/new" }.should route_to(:controller => 'nodes', :action => 'new', :user_id => u.to_param, :pile_id => p.id.to_s)
    end
    
    it "recognizes and generates #show" do
      u = Factory.create(:user)
      p = u.piles.first
      n = p.nodes.first
      { :get => "#{u.login}/piles/#{p.id}/nodes/#{n.id}" }.should route_to(:controller => 'nodes', :action => 'show', :user_id => u.to_param, :pile_id => p.id.to_s, :id => n.id.to_s)
    end
    
    it "recognizes and generates #edit" do
      u = Factory.create(:user)
      p = u.piles.first
      n = p.nodes.first
      { :get => "#{u.login}/piles/#{p.id}/nodes/#{n.id}/edit" }.should route_to(:controller => 'nodes', :action => 'edit', :user_id => u.to_param, :pile_id => p.id.to_s, :id => n.id.to_s)
    end
    
    it "recognizes and generates #create" do
      u = Factory.create(:user)
      p = u.piles.first
      { :post => "#{u.login}/piles/#{p.id}/nodes" }.should route_to(:controller => 'nodes', :action => 'create', :user_id => u.to_param, :pile_id => p.id.to_s)
    end
    
    it "recognizes and generates #update" do
      u = Factory.create(:user)
      p = u.piles.first
      n = p.nodes.first
      { :put => "#{u.login}/piles/#{p.id}/nodes/#{n.id}" }.should route_to(:controller => 'nodes', :action => 'update', :user_id => u.to_param, :pile_id => p.id.to_s, :id => n.id.to_s)
    end
    
    it "recognizes and generates #destroy" do
      u = Factory.create(:user)
      p = u.piles.first
      n = p.nodes.first
      { :delete => "#{u.login}/piles/#{p.id}/nodes/#{n.id}" }.should route_to(:controller => 'nodes', :action => 'destroy', :user_id => u.to_param, :pile_id => p.id.to_s, :id => n.id.to_s)
    end
  end
end
