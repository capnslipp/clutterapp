class PilesController < ApplicationController
  before_filter :no_cache
  before_filter :authorize
  before_filter :have_owner
  before_filter :have_pile, :only => [:show, :edit, :update, :destroy]
  
  
  # GET /piles
  # GET /piles.xml
  def index
    @user = active_owner
    @root_pile = @user.root_pile
  end
  
  
  # GET /piles/1
  # GET /piles/1.xml
  def show
    @owner = active_owner
    @piles = [active_owner.root_pile]
    @pile = active_pile
    
    @enable_item_view_js = true
  end
  
end
