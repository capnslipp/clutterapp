# requires Mocha

require 'test_helper'
require 'performance_test_help'


# Profiling results for each test method are written to tmp/performance.
class BrowsingTest < ActionController::PerformanceTest
  dataset :users, :piles, :nodes
  
  
  def setup
    bypass_authentication
    
    @user = users(:slippy_douglas)
    @pile = @user.root_pile
    
    26.times do
      @pile.nodes.rand.children.create!(:prop => Prop.rand_new)
    end
  end
  
  
  #def test_homepage
  #  get '/'
  #  
  #  bypass_authentication
  #  
  #  get '/'
  #end
  
  
  def test_piles
    bypass_authentication
    
    7.times do
      get "/#{@user.to_param}/piles/#{@pile.to_param}"
      assert_response :success
    end
  end
  
  
protected
  
  def bypass_authentication
    PilesController.any_instance.stubs(
      :current_user => @user
    )
  end
  
end
