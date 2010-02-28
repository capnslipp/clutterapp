class PilesController < ApplicationController
  before_filter :no_cache
  before_filter :authorize
  before_filter :have_owner
  before_filter :have_pile, :only => [:show, :edit, :update, :destroy]
  
  
  # GET /piles
  # GET /piles.xml
  def index
    @owner = active_owner
    @piles = active_owner.piles.master
  end
  
  
  # GET /piles/1
  # GET /piles/1.xml
  def show
    @owner = active_owner
    @piles = active_owner.piles.master
    @pile = active_pile
    
    @enable_item_view_js = true
  end
  
  
  # GET /piles/new
  # GET /piles/new.xml
  def new
    @owner = active_owner
    @pile = active_owner.piles.build
  end
  
  
  # GET /piles/1/edit
  def edit
    @owner = active_owner
    @pile = active_owner.piles.find(params[:id])
  end
  
  
  # POST /piles
  # POST /piles.xml
  def create
    @owner = active_owner
    pile_params = params[:pile] || {}
    @pile = active_owner.piles.build(pile_params)
    
    if @pile.save
      flash[:notice] = 'Pile was successfully created.'
      redirect_to [@owner, @pile]
    else
      render :action => 'new'
    end
  end
  
  
  # PUT /piles/1
  # PUT /piles/1.xml
  def update
    @owner = active_owner
    @pile = active_owner.piles.find(params[:id])
    
    if @pile.update_attributes(params[:pile])
      flash[:notice] = 'Pile was successfully updated.'
      redirect_to [@owner, @pile]
    else
      render :action => 'edit'
    end
  end
  
  
  # DELETE /piles/1
  # DELETE /piles/1.xml
  def destroy
    @owner = active_owner
    @pile = active_owner.piles.find(params[:id])
    
    if @pile.destroy
      redirect_to [@owner, :piles]
    else
      render :action => 'index'
    end
  end
  
end
