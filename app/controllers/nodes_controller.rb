class NodesController < ApplicationController
  include CellHelper
  include ERB::Util
  layout nil
  
  before_filter :be_xhr_request
  before_filter :authorize
  before_filter :have_owner
  before_filter :have_pile
  
  
  # PUT /items/1/update_check_prop_checked
  def update_check_prop_checked
    logger.prefixed 'update_check_prop_checked', :light_green, 'params: ' + params.inspect
    @node = active_pile.nodes.find(params[:id])
    @prop = @node.prop
    @prop.checked = params[:checked]
    @prop.save!
    render :update do |page|
      page.call 'updateCheckPropField', "check_prop_#{@prop.id}", @prop.checked?
    end
  end
  
  
  # GET /nodes/new
  def new
    if params[:node]
      node_attrs = params[:node]
    else
      node_attrs = {}
      raise 'type param is required' if params[:type].nil?
      prop_class = Prop.class_from_type(params[:type])
      node_attrs[:prop] = prop_class.filler_new
    end
    
    @parent = active_pile.nodes.find(params[:parent_id])
    node_attrs.merge!(:pile => @parent.pile)
    @node = @parent.children.build(node_attrs)
    
    @cell_state = :new
    render :partial => 'item', :locals => {:item => @node}
  end
  
  
  # POST /nodes
  def create
    node_attrs = params[:node] || {}
    prop_class = Prop.class_from_type(params[:type])
    node_attrs[:prop] = prop_class.new(node_attrs.delete(:prop_attributes))
    
    node_attrs[:pile] = Pile.find(params[:pile_id])
    
    @parent = active_pile.nodes.find(params[:parent_id])
    @node = @parent.children.build(node_attrs)
    
    @node.save!
    
    @cell_state = :show
    render :partial => 'item', :locals => {:item => @node}
  end
  
  
  # GET /nodes/1/edit
  def edit
    @node = active_pile.nodes.find params[:id]
    
    render :inline => render_cell(cell_for_node(@node), :edit, :node => @node)
  end
  
  
  # PUT /nodes/1
  def update
    @node = active_pile.nodes.find(params[:id])
    
    @node.update_attributes(params[:node])
    @node.prop.update_attributes(params[:node][:prop_attributes]) # Node's "accepts_nested_attributes_for :prop" seems not to be working
    
    if @node.save
      render :inline => render_cell(cell_for_node(@node), :show, :node => @node)
    else
      render :nothing => true, :status => :bad_request
    end
  end
  
  
  # PUT /nodes/1/move/:dir
  def move
    dir = params[:dir].to_sym
    
    @node = active_pile.nodes.find(params[:id])
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
    return render :nothing => true , :status => :bad_request if cant_move
    
    case dir
      when :up:   @node.move_to_left_of orig_ref_node
      when :down: @node.move_to_right_of orig_ref_node
      when :in:   @node.move_to_child_of orig_ref_node
      when :out:  @node.move_to_right_of orig_ref_node
    end
    
    orig_ref_node.reload #:select => :version # doesn't work some times, possibly due to being a named_scope?
    @node.reload #:select => :version # doesn't work some times, possibly due to being a named_scope?
    
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
    @node = active_pile.nodes.find(params[:id])
    orig_parent_node = @node.parent
    @node.destroy
    orig_parent_node.after_child_destroy
    
    render :nothing => true, :status => :accepted
  end
  
end
