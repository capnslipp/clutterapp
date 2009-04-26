class NodesController < ApplicationController
  include NodesHelper
  layout nil
  
  
  # GET /nodes
  # GET /nodes.xml
  #def index
  #  @nodes = Node.all
  #  
  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.xml  { render :xml => @nodes }
  #  end
  #end
  
  # GET /nodes/1
  # GET /nodes/1.xml
  #def show
  #  @node = Node.find(params[:id])
  #  
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.xml  { render :xml => @node }
  #  end
  #end
  
  # GET /nodes/new
  # GET /nodes/new.xml
  #def new
  #  @node = Node.new
  #  
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.xml  { render :xml => @node }
  #  end
  #end
  
  # GET /nodes/1/edit
  #def edit
  #  @node = Node.find(params[:id])
  #end
  
  # POST /nodes
  # POST /nodes.xml
  def create
    node_creation_args = params[:node] || {}
    node_creation_args.update( :prop => Prop.class_from_type(params[:type]).rand ) unless params[:type].nil?
    
    @parent = Node.find(params[:parent_id])
    @node = @parent.create_child!(node_creation_args)
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.insert_html :before, dom_id(@parent, 'item-new'), render_cell(cell_for_node(@node), :show_item, :node => @node)
        end
      end # format.js
    end # respond_to
  end
  
  # PUT /nodes/up/1
  # PUT /nodes/up/1.xml
  def move_up
    @node = Node.find(params[:id])
    @orig_left_sibling = @node.left_sibling
    
    if @orig_left_sibling.nil?
      render :nothing => true
      return
    end
    
    @node.move_to_left_of @orig_left_sibling
    
    @node_sel = dom_id(@node, 'item')
    @orig_left_sibling_sel = dom_id(@orig_left_sibling, 'item')
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.remove @node_sel
          page.insert_html :before, @orig_left_sibling_sel, render_cell(cell_for_node(@node), :show_item, :node => @node)
          page.visual_effect :highlight, @node_sel
        end
      end # format.js
    end # respond_to
  end
  
  # PUT /nodes/down/1
  # PUT /nodes/down/1.xml
  def move_down
    @node = Node.find(params[:id])
    @orig_right_sibling = @node.right_sibling
    
    if @orig_right_sibling.nil?
      render :nothing => true
      return
    end
    
    @node.move_to_right_of @orig_right_sibling
    
    @node_sel = dom_id(@node, 'item')
    @orig_right_sibling_sel = dom_id(@orig_right_sibling, 'item')
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.remove @node_sel
          page.insert_html :after, @orig_right_sibling_sel, render_cell(cell_for_node(@node), :show_item, :node => @node)
          page.visual_effect :highlight, @node_sel
        end
      end # format.js
    end # respond_to
  end
  
  # PUT /nodes/in/1
  # PUT /nodes/in/1.xml
  def move_in
    @node = Node.find(params[:id])
    @orig_left_sibling = @node.left_sibling
    
    if @orig_left_sibling.nil?
      render :nothing => true
      return
    end
    
    @node.move_to_child_of @orig_left_sibling
    
    @node_sel = dom_id(@node, 'item')
    @orig_left_sibling_list_sel = "##{dom_id(@orig_left_sibling, 'item')} > .node.list"
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.remove @node_sel
          page.insert_html :bottom, @orig_left_sibling_list_sel, render_cell(cell_for_node(@node), :show_item, :node => @node)
          page.visual_effect :highlight, @node_sel
        end
      end # format.js
    end # respond_to
  end
  
  # PUT /nodes/out/1
  # PUT /nodes/out/1.xml
  def move_out
    @node = Node.find(params[:id])
    @orig_parent = @node.parent
    
    if @orig_parent.nil? || @orig_parent.root?
      render :nothing => true
      return
    end
    
    @node.move_to_right_of @orig_parent
    
    @node_sel = dom_id(@node, 'item')
    @orig_parent_sel = dom_id(@orig_parent, 'item')
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.remove @node_sel
          page.insert_html :after, @orig_parent_sel, render_cell(cell_for_node(@node), :show_item, :node => @node)
          page.visual_effect :highlight, @node_sel
        end
      end # format.js
    end # respond_to
  end
  
  # PUT /nodes/1
  # PUT /nodes/1.xml
  #def update
  #  @node = Node.find(params[:id])
  #  
  #  respond_to do |format|
  #    if @node.update_attributes(params[:node])
  #      flash[:notice] = 'Node was successfully updated.'
  #      format.html { redirect_to(@node) }
  #      format.xml  { head :ok }
  #    else
  #      format.html { render :action => "edit" }
  #      format.xml  { render :xml => @node.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end
  
  # DELETE /nodes/1
  # DELETE /nodes/1.xml
  def destroy
    @node = Node.find(params[:id])
    @node.destroy
    
    @node_sel = dom_id(@node, 'item')
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.remove @node_sel
        end
      end # format.js
    end # respond_to
  end
  
end
