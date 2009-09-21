class NodesController < ApplicationController
  include NodesHelper
  include ERB::Util
  layout nil
  
  
  #in_place_edit_for :check_prop, :checked
  #def set_check_prop_checked
  #  prop = CheckProp.find(params[:id]) 
  #  prop.checked = params[:value]
  #  prop.save!
  #  render :text => check_box_tag("check_prop_#{prop.id}", '1', prop.checked?)
  #end
  
  # PUT /items/1/update_checkbox
  def update_check_prop_checked
    logger.debug logger.prefix('update_check_prop_checked', 31) + 'params: ' + params.inspect
    prop = CheckProp.find(params[:id])
    prop.checked = params[:checked]
    prop.save!
    render :update do |page|
      page.call 'updateCheckPropField', "check_prop_#{prop.id}", prop.checked?
    end
  end
  
  in_place_edit_for :note_prop, :note
  def set_note_prop_note
    logger.debug logger.prefix('set_note_prop_note', 31) + 'params: ' + params.inspect
    prop = NoteProp.find(params[:id]) 
    prop.note = params[:value]
    prop.save!
    render :text => html_escape(prop.note)
  end
  
  in_place_edit_for :priority_prop, :priority
  def set_priority_prop_priority
    logger.debug logger.prefix('set_priority_prop_priority', 31) + 'params: ' + params.inspect
    prop = PriorityProp.find(params[:id]) 
    prop.priority = params[:value]
    prop.save!
    render :text => prop.priority
  end
  
  in_place_edit_for :tag_prop, :tag
  def set_tag_prop_tag
    logger.debug logger.prefix('set_tag_prop_tag', 31) + 'params: ' + params.inspect
    prop = TagProp.find(params[:id]) 
    prop.tag = params[:value].upcase
    prop.save!
    render :text => prop.tag
  end
  
  in_place_edit_for :text_prop, :text
  def set_text_prop_text
    logger.debug logger.prefix('set_text_prop_text', 31) + 'params: ' + params.inspect
    prop = TextProp.find(params[:id]) 
    prop.text = params[:value]
    prop.save!
    render :text => html_escape(prop.text)
  end
  
  in_place_edit_for :time_prop, :time
  def set_time_prop_time
    logger.debug logger.prefix('set_time_prop_time', 31) + 'params: ' + params.inspect
    prop = TimeProp.find(params[:id]) 
    prop.time = Time.zone.parse(params[:value])
    prop.save!
    render :text => prop.time
  end
  
  # GET /nodes
  # GET /nodes.xml
  def index
    @piles_owner = User.find_by_login(params[:user_login]) unless params[:user_login].nil?
    @piles_owner = User.find(params[:user_id]) if @piles_owner.nil?
    
    if @piles_owner.nil?
      flash[:error] = "Sorry, we know of no such user."
      redirect_to home_url
    elsif current_user == @piles_owner
      @root_node = current_user.pile.root_node
      render :partial => 'users/show_pile', :layout => 'application'
    else
      flash[:warning] = "You can't really see this pile since, well, it's not yours. Maybe someday though."
      redirect_to home_url
    end
    #@nodes = Node.all
    #
    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.xml  { render :xml => @nodes }
    #end
  end
  
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
    unless params[:type].nil?
      filler_prop = Prop.class_from_type(params[:type]).filler
      node_creation_args.update( :prop => filler_prop )
    end
    
    @parent = Node.find(params[:parent_id])
    @node = @parent.create_child!(node_creation_args)
    @left_sibling = @node.left_sibling
    @left_sibling.reload :select => :version unless @left_sibling.nil?
    
    @node_sel = dom_id(@node, 'item')
    @left_sibling_manip_buttons_sel = "##{dom_id(@left_sibling, 'item-content')} > .manipulate.buttons" unless @left_sibling.nil?
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.insert_html :before, dom_id(@parent, 'item-new'), render_cell(cell_for_node(@node), :show_item, :node => @node)
          page.replace @left_sibling_manip_buttons_sel, :partial => 'action_buttons', :locals => {:item => @left_sibling} unless @left_sibling.nil?
          page.visual_effect :highlight, @node_sel
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
    @orig_left_sibling.reload :select => :version
    @node.reload :select => :version
    
    @node_sel = dom_id(@node, 'item')
    @orig_left_sibling_sel = dom_id(@orig_left_sibling, 'item')
    @orig_left_sibling_manip_buttons_sel = "##{dom_id(@orig_left_sibling, 'item-content')} > .manipulate.buttons"
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.remove @node_sel
          page.insert_html :before, @orig_left_sibling_sel, render_cell(cell_for_node(@node), :show_item, :node => @node)
          page.replace @orig_left_sibling_manip_buttons_sel, :partial => 'action_buttons', :locals => {:item => @orig_left_sibling}
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
    @orig_right_sibling.reload :select => :version
    @node.reload :select => :version
    
    @node_sel = dom_id(@node, 'item')
    @orig_right_sibling_sel = dom_id(@orig_right_sibling, 'item')
    @orig_right_sibling_manip_buttons_sel = "##{dom_id(@orig_right_sibling, 'item-content')} > .manipulate.buttons"
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.remove @node_sel
          page.insert_html :after, @orig_right_sibling_sel, render_cell(cell_for_node(@node), :show_item, :node => @node)
          page.replace @orig_right_sibling_manip_buttons_sel, :partial => 'action_buttons', :locals => {:item => @orig_right_sibling}
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
    @orig_left_sibling.reload :select => :version
    @node.reload :select => :version
    
    @node_sel = dom_id(@node, 'item')
    @orig_left_sibling_list_sel = "##{dom_id(@orig_left_sibling, 'item')} > .node.list"
    @orig_left_sibling_manip_buttons_sel = "##{dom_id(@orig_left_sibling, 'item-content')} > .manipulate.buttons"
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.remove @node_sel
          page.insert_html :bottom, @orig_left_sibling_list_sel, render_cell(cell_for_node(@node), :show_item, :node => @node)
          page.replace @orig_left_sibling_manip_buttons_sel, :partial => 'action_buttons', :locals => {:item => @orig_left_sibling}
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
    @orig_parent.reload :select => :version
    @node.reload :select => :version
    
    @node_sel = dom_id(@node, 'item')
    @orig_parent_sel = dom_id(@orig_parent, 'item')
    @orig_parent_manip_buttons_sel = "##{dom_id(@orig_parent, 'item-content')} > .manipulate.buttons"
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.remove @node_sel
          page.insert_html :after, @orig_parent_sel, render_cell(cell_for_node(@node), :show_item, :node => @node)
          page.replace @orig_parent_manip_buttons_sel, :partial => 'action_buttons', :locals => {:item => @orig_parent}
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
    @orig_parent = @node.parent
    @orig_left_sibling = @node.left_sibling
    @orig_right_sibling = @node.right_sibling
    @node.destroy
    @orig_parent.after_child_destroy
    
    @node_sel = dom_id(@node, 'item')
    
    @orig_left_sibling_manip_buttons_sel = "##{dom_id(@orig_left_sibling, 'item-content')} > .manipulate.buttons" unless @orig_left_sibling.nil?
    @orig_right_sibling_manip_buttons_sel = "##{dom_id(@orig_right_sibling, 'item-content')} > .manipulate.buttons" unless @orig_right_sibling.nil?
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.remove @node_sel
          page.replace @orig_left_sibling_manip_buttons_sel, :partial => 'action_buttons', :locals => {:item => @orig_left_sibling} unless @orig_left_sibling.nil?
          page.replace @orig_right_sibling_manip_buttons_sel, :partial => 'action_buttons', :locals => {:item => @orig_right_sibling} unless @orig_right_sibling.nil?
        end
      end # format.js
    end # respond_to
  end
  
end
