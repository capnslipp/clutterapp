class NodesController < ApplicationController
  include CellHelper
  include ERB::Util
  layout nil
  
  before_filter :authorize
  
  
  # PUT /items/1/update_check_prop_checked
  def update_check_prop_checked
    logger.prefixed 'update_check_prop_checked', :light_green, 'params: ' + params.inspect
    node = Node.find(params[:id])
    prop = node.prop
    prop.checked = params[:checked]
    prop.save!
    render :update do |page|
      page.call 'updateCheckPropField', "check_prop_#{prop.id}", prop.checked?
    end
  end
  
  
  # POST /nodes
  # POST /nodes.xml
  def create
    node_creation_args = params[:node] || {}
    unless params[:type].nil?
      filler_prop = Prop.class_from_type(params[:type]).filler_new
      node_creation_args.update( :prop => filler_prop )
    end
    
    @parent = Node.find(params[:parent_id])
    @node = @parent.children.create!(node_creation_args)
    @left_sibling = @node.left_sibling
    @left_sibling.reload :select => :version unless @left_sibling.nil?
    
    node_sel = dom_id(@node, 'item')
    
    if request.xhr?
      return render(:inline => render_cell(cell_for_node(@node), :new, :node => @node), :status => :ok)
    end
    
    render(:nothing => true, :status => 418)
  end
  
  
  # GET /nodes/1/edit
  def edit
    @pile_owner = User.find_by_login(params[:user_id]) unless params[:user_id].nil?
    
    if @pile_owner.nil?
      flash[:warning] = "No such user exists."
      redirect_to user_url(current_user)
      
    elsif @pile_owner != current_user
      flash[:warning] = "You can't really see this pile since, well, it's not yours. Maybe someday though."
      redirect_to user_url(current_user)
      
    else
      @pile = @pile_owner.piles.find params[:pile_id]
      @node = @pile.nodes.find params[:id]
      
      if request.xhr?
        return render(:inline => render_cell(cell_for_node(@node), :edit, :node => @node), :status => :ok)
      end
      
      render(:nothing => true, :status => 418)
    end
  end
  
  
  # PUT /nodes/1
  def update
    @pile_owner = User.find_by_login(params[:user_id]) unless params[:user_id].nil?
    
    if @pile_owner.nil?
      flash[:warning] = "No such user exists."
      redirect_to user_url(current_user)
      
    elsif @pile_owner != current_user
      flash[:warning] = "You can't really see this pile since, well, it's not yours. Maybe someday though."
      redirect_to user_url(current_user)
      
    else
      @pile = @pile_owner.piles.find(params[:pile_id])
      @node = @pile.nodes.find(params[:id])
      @prop = @node.prop
      
      if @node.update_attributes(params[:node])
        if request.xhr?
          return render(:inline => render_cell(cell_for_node(@node), :update, :node => @node), :status => :ok)
        end
      end
      
      render(:nothing => true, :status => 418)
    end
  end
  
  
  # PUT /nodes/1/move/:dir
  def move
    dir = params[:dir].to_sym
    
    @node = Node.find(params[:id])
    orig_ref_node = case dir
      when :up:   @node.left_sibling
      when :down: @node.right_sibling
      when :in:   @node.left_sibling
      when :out:  @node.parent
    end
    
    cant_move = case dir
      when :up:   orig_ref_node.nil?
      when :down: orig_ref_node.nil?
      when :in:   orig_ref_node.nil?
      when :out:  orig_ref_node.nil? || orig_ref_node.root?
      else        true
    end
    return render(:nothing => true , :status => 418) if cant_move
    
    case dir
      when :up:   @node.move_to_left_of orig_ref_node
      when :down: @node.move_to_right_of orig_ref_node
      when :in:   @node.move_to_child_of orig_ref_node
      when :out:  @node.move_to_right_of orig_ref_node
    end
    
    orig_ref_node.reload :select => :version
    @node.reload :select => :version
    
    node_sel = dom_id(@node, 'item_for')
    
    orig_ref_sel = case dir
      when :up:   "##{dom_id(orig_ref_node, 'item_for')}"
      when :down: "##{dom_id(orig_ref_node, 'item_for')}"
      when :in:   "##{dom_id(orig_ref_node, 'item_for')} > .node.list"
      when :out:  "##{dom_id(orig_ref_node, 'item_for')}"
    end
    insert_pos = case dir
      when :up:   :before
      when :down: :after
      when :in:   :bottom
      when :out:  :after
    end
    
    respond_to do |format|
      format.js do
        # keeping this as RJS for now, since it will soon be replaced with a drag-and-drop move system
        render :update do |page|
          page.call 'collapseActionBar'
          page.remove node_sel
          page.insert_html insert_pos, orig_ref_sel, render_cell(cell_for_node(@node), :show, :node => @node)
          page.visual_effect :highlight, node_sel
        end
      end # format.js
    end # respond_to
  end
  
  
  # DELETE /nodes/1
  # DELETE /nodes/1.xml
  def destroy
    @node = Node.find(params[:id])
    orig_parent_node = @node.parent
    orig_left_node = @node.left_sibling
    orig_right_node = @node.right_sibling
    @node.destroy
    orig_parent_node.after_child_destroy
    
    node_sel = dom_id(@node, 'item_for')
    
    if request.xhr?
      return render(:nothing => true, :status => :ok)
    end
    
    render(:nothing => true , :status => 418)
  end
  
end
