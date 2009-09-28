require 'test_helper'
require 'performance_test_help'

# Profiling results for each test method are written to tmp/performance.
class BrowsingTest < ActionController::PerformanceTest
  
  def test_homepage
    get '/'
  end
  
  def test_piles
    bypass_authentication
    
    User.all.each do |u|
      u.piles.each do |p|
        p.root_node # create the root node first
        10.times { p.nodes.rand.create_child!(:prop => Prop.rand) }
        get "/#{u.to_param}/piles/#{p.to_param}"
        assert_response :success
      end
    end
  end
  
  
protected
  
  def bypass_authentication
    PilesController.any_instance.stubs(:logged_in? => true, :current_user => User.first)
  end
  
end
