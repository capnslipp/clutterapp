class PilesController < ApplicationController
  before_filter :authorize
  
  
  # GET /piles
  # GET /piles.xml
  def index
    @piles = Pile.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @piles }
    end
  end
  
  
  # GET /piles/1
  # GET /piles/1.xml
  def show
    @pile_owner = User.find_by_login(params[:user_id]) unless params[:user_id].nil?
    
    if @pile_owner.nil?
      flash[:warning] = "No such user exists."
      redirect_to user_url(current_user)
      
    elsif @pile_owner != current_user
      flash[:warning] = "You can't really see this pile since, well, it's not yours. Maybe someday though."
      redirect_to user_url(current_user)
      
    else
      @pile = @pile_owner.piles.find(params[:id])
      @base_node = @pile.root_node
      
      respond_to do |format|
        format.html # show.html.erb
        #format.xml  { render :xml => @nodes }
      end
    end
  end
  
  
  # GET /piles/new
  # GET /piles/new.xml
  def new
    @pile = Pile.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pile }
    end
  end
  
  
  # GET /piles/1/edit
  def edit
    @pile = Pile.find(params[:id])
  end
  
  
  # POST /piles
  # POST /piles.xml
  def create
    @pile = Pile.new(params[:pile])
    
    respond_to do |format|
      if @pile.save
        flash[:notice] = 'Pile was successfully created.'
        format.html { redirect_to(@pile) }
        format.xml  { render :xml => @pile, :status => :created, :location => @pile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pile.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  # PUT /piles/1
  # PUT /piles/1.xml
  def update
    @pile = Pile.find(params[:id])
    
    respond_to do |format|
      if @pile.update_attributes(params[:pile])
        flash[:notice] = 'Pile was successfully updated.'
        format.html { redirect_to(@pile) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pile.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  # DELETE /piles/1
  # DELETE /piles/1.xml
  def destroy
    @pile = Pile.find(params[:id])
    @pile.destroy
    
    respond_to do |format|
      format.html { redirect_to(piles_url) }
      format.xml  { head :ok }
    end
  end
  
end
