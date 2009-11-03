class PilesController < ApplicationController
  before_filter :authorize
  before_filter :have_owner
  before_filter :have_pile, :only => [:show, :edit, :update, :destroy]
  
  
  # GET /piles
  # GET /piles.xml
  def index
    @piles = active_owner.piles
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  
  # GET /piles/1
  # GET /piles/1.xml
  def show
    @pile = active_pile
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  
  # GET /piles/new
  # GET /piles/new.xml
  def new
    @pile = active_owner.piles.build
    
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  
  # GET /piles/1/edit
  def edit
    @pile = active_owner.piles.find(params[:id])
    
    respond_to do |format|
      format.html # edit.html.erb
    end
  end
  
  
  # POST /piles
  # POST /piles.xml
  def create
    pile_params = params[:pile] || {}
    #pile_params.update(:owner => active_owner) # necessary?
    @pile = active_owner.piles.build(pile_params)
    
    respond_to do |format|
      
      if @pile.save
        flash[:notice] = 'Pile was successfully created.'
        format.html { redirect_to @pile }
      else
        format.html { render :action => 'new' }
      end
      
    end
  end
  
  
  # PUT /piles/1
  # PUT /piles/1.xml
  def update
    @pile = active_owner.piles.find(params[:id])
    
    respond_to do |format|
      
      if @pile.update_attributes(params[:pile])
        flash[:notice] = 'Pile was successfully updated.'
        format.html { redirect_to @pile }
      else
        format.html { render :action => 'edit' }
      end
      
    end
  end
  
  
  # DELETE /piles/1
  # DELETE /piles/1.xml
  def destroy
    @pile = active_owner.piles.find(params[:id])
    
    respond_to do |format|
      
      if @pile.destroy
        format.html { redirect_to piles_url(@pile) }
      else
        format.html { render :action => 'index' }
      end 
      
    end
  end
  
end
