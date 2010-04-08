class LinkPropsController < ApplicationController
  # GET /link_props
  # GET /link_props.xml
  def index
    @link_props = LinkProp.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @link_props }
    end
  end

  # GET /link_props/1
  # GET /link_props/1.xml
  def show
    @link_prop = LinkProp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @link_prop }
    end
  end

  # GET /link_props/new
  # GET /link_props/new.xml
  def new
    @link_prop = LinkProp.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @link_prop }
    end
  end

  # GET /link_props/1/edit
  def edit
    @link_prop = LinkProp.find(params[:id])
  end

  # POST /link_props
  # POST /link_props.xml
  def create
    @link_prop = LinkProp.new(params[:link_prop])

    respond_to do |format|
      if @link_prop.save
        flash[:notice] = 'LinkProp was successfully created.'
        format.html { redirect_to(@link_prop) }
        format.xml  { render :xml => @link_prop, :status => :created, :location => @link_prop }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @link_prop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /link_props/1
  # PUT /link_props/1.xml
  def update
    @link_prop = LinkProp.find(params[:id])

    respond_to do |format|
      if @link_prop.update_attributes(params[:link_prop])
        flash[:notice] = 'LinkProp was successfully updated.'
        format.html { redirect_to(@link_prop) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @link_prop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /link_props/1
  # DELETE /link_props/1.xml
  def destroy
    @link_prop = LinkProp.find(params[:id])
    @link_prop.destroy

    respond_to do |format|
      format.html { redirect_to(link_props_url) }
      format.xml  { head :ok }
    end
  end
end
