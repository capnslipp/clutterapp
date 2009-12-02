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
    node_attrs = params.delete(:node) || {}
    
    @parent = active_pile.nodes.find(node_attrs.delete(:parent_id))
    node_attrs[:pile] = @parent.pile
    
    raise 'node[prop_type] param is required' if node_attrs[:prop_type].nil?
    node_attrs[:prop_attributes] ||= {}
    node_attrs[:prop_attributes][:type] = node_attrs.delete(:prop_type)
    
    @node = @parent.children.build(node_attrs)
    
    
    if params[:add]
      add_attrs = params.delete(:add)
      
      raise 'add[prop_type] param is required' if add_attrs[:prop_type].nil?
      add_attrs[:prop_attributes] ||= {}
      add_attrs[:prop_attributes][:type] = add_attrs.delete(:prop_type)
      
      @node.children.build(add_attrs)
    end
    
    
    @cell_state = :new
    render :partial => 'item', :locals => {:item => @node}
  end
  
  
  # POST /nodes
  def create
    node_attrs = params.delete(:node) || {}
    
    @parent = active_pile.nodes.find(node_attrs.delete(:parent_id))
    node_attrs[:pile] = @parent.pile
    
    raise 'node[prop_type] param is required' if node_attrs[:prop_type].nil?
    node_attrs[:prop_attributes] ||= {}
    node_attrs[:prop_attributes][:type] = node_attrs.delete(:prop_type)
    
    @node = @parent.children.build(node_attrs)
    
    @node.children.each do |child|
      child.parent = @node
      child.pile = @node.pile
    end
    
    @node.save!
    
    
    @cell_state = :show
    render :partial => 'item', :locals => {:item => @node}
  end
  
  
  # GET /nodes/1/edit
  def edit
    @node = active_pile.nodes.find(params[:id])
    
    
    params[:node][:children_attributes].each do |i, child_attrs| # since Rails won't do it for some dumb reason
      child_id = child_attrs[:id]
      delete_child = child_attrs.delete(:_destroy) # otherwise Rails complains
      
      if child_id
        child = @node.children.find(child_id)
        
        if child && delete_child.present?
          #child.destroy()
          @node.children.destroy(child)
        end
      else
        if delete_child.present?
          params[:node][:children_attributes].delete(i)
        else
          @node.children.create(child_attrs.merge(
            :parent => @node,
            :pile => @node.pile
          ))
        end
      end
    end if params[:node] && params[:node][:children_attributes]
    
    @node.attributes = params.delete(:node)
    
    
    if params[:add]
      add_attrs = params.delete(:add)
      
      raise 'add[prop_type] param is required' if add_attrs[:prop_type].nil?
      add_attrs[:prop_attributes] ||= {}
      add_attrs[:prop_attributes][:type] = add_attrs.delete(:prop_type)
      
      @node.children.build(add_attrs)
    end
    
    
    render :inline => render_cell('node_body', :edit, :node => @node)
  end
  
  
  # PUT /nodes/1
  def update
    @node = active_pile.nodes.find(params[:id])
    
    @node.update_attributes!(params[:node])
    @node.prop.update_attributes!(params[:node][:prop_attributes]) # since Rails won't do it through a polymorphic relation
    
    
    params[:node][:children_attributes].each_value do |child_attrs| # since Rails won't do it for some dumb reason
      child_id = child_attrs.delete(:id)
      delete_child = child_attrs.delete(:_destroy) # otherwise Rails complains
      
      if child_id
        child = @node.children.find(child_id)
        
        child.update_attributes!(child_attrs)
        child.prop.update_attributes!(child_attrs[:prop_attributes]) # since Rails won't do it through a polymorphic relation
      else
        @node.children.create(child_attrs.merge(
          :parent => @node,
          :pile => @node.pile
        ))
      end
    end if params[:node] && params[:node][:children_attributes]
    
    
    if @node.save
      render :inline => render_cell('node_body', :show, :node => @node)
    else
      render :nothing => true, :status => :bad_request
    end
  end
  
  
  # PUT /nodes/1/move/:dir
  def move
    dir = params[:dir].to_sym
    
    @node = active_pile.nodes.find(params[:id])
    orig_ref_node = case dir
      when :up:   @node.left_non_badgeable_sibling
      when :down: @node.right_non_badgeable_sibling
      when :in:   @node.left_non_badgeable_sibling
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
      when :out:  "##{dom_id(orig_ref_node, 'item_for')} > .node.list"
    end
    insert_pos = case dir
      when :up:   :before
      when :down: :after
      when :in:   :bottom
      when :out:  :bottom
    end
    
    respond_to do |format|
      format.js do
        # keeping this as RJS for now, since it will soon be replaced with a drag-and-drop move system
        render :update do |page|
          page.call 'collapseActionBar'
          page.remove node_sel
          @cell_state = :show
          page.insert_html insert_pos, orig_ref_sel, :partial => 'item', :locals => {:item => @node}
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
