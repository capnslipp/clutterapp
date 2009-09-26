class NodesController < ApplicationController
  include NodesHelper
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
  
  # PUT /items/1/set_note_prop_note
  def set_note_prop_note
    logger.prefixed 'set_note_prop_note', :light_green, 'params: ' + params.inspect
    node = Node.find(params[:id])
    prop = node.prop
    prop.note = params[:value]
    prop.save!
    render :text => html_escape(prop.note)
  end
  
  # PUT /items/1/set_priority_prop_priority
  def set_priority_prop_priority
    logger.prefixed 'set_priority_prop_priority', :light_green, 'params: ' + params.inspect
    node = Node.find(params[:id])
    prop = node.prop
    prop.priority = params[:value]
    prop.save!
    render :text => prop.priority
  end
  
  # PUT /items/1/set_tag_prop_tag
  def set_tag_prop_tag
    logger.prefixed 'set_tag_prop_tag', :light_green, 'params: ' + params.inspect
    node = Node.find(params[:id])
    prop = node.prop
    prop.tag = params[:value].upcase
    prop.save!
    render :text => prop.tag
  end
  
  # PUT /items/1/set_text_prop_text
  def set_text_prop_text
    logger.prefixed 'set_text_prop_text', :light_green, 'params: ' + params.inspect
    node = Node.find(params[:id])
    prop = node.prop
    prop.text = params[:value]
    prop.save!
    render :text => html_escape(prop.text)
  end
  
  # PUT /items/1/set_time_prop_time
  def set_time_prop_time
    logger.prefixed 'set_time_prop_time', :light_green, 'params: ' + params.inspect
    node = Node.find(params[:id])
    prop = node.prop
    prop.time = Time.zone.parse(params[:value])
    prop.save!
    render :text => prop.time
  end
  
  
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
    
    node_sel = dom_id(@node, 'item')
    @left_sibling_manip_buttons_sel = "##{dom_id(@left_sibling, 'item-content')} > .manipulate.buttons" unless @left_sibling.nil?
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.insert_html :before, dom_id(@parent, 'item-new'), render_cell(cell_for_node(@node), :show, :node => @node)
          page.replace @left_sibling_manip_buttons_sel, :partial => 'action_buttons', :locals => {:item => @left_sibling} unless @left_sibling.nil?
          page.visual_effect :highlight, node_sel
        end
      end # format.js
    end # respond_to
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
    return render :nothing => true if cant_move
    
    case dir
      when :up:   @node.move_to_left_of orig_ref_node
      when :down: @node.move_to_right_of orig_ref_node
      when :in:   @node.move_to_child_of orig_ref_node
      when :out:  @node.move_to_right_of orig_ref_node
    end
    
    orig_ref_node.reload :select => :version
    @node.reload :select => :version
    
    node_sel = dom_id(@node, 'item')
    
    orig_ref_sel = case dir
      when :up:   "##{dom_id(orig_ref_node, 'item')}"
      when :down: "##{dom_id(orig_ref_node, 'item')}"
      when :in:   "##{dom_id(orig_ref_node, 'item')} > .node.list"
      when :out:  "##{dom_id(orig_ref_node, 'item')}"
    end
    insert_pos = case dir
      when :up:   :before
      when :down: :after
      when :in:   :bottom
      when :out:  :after
    end
    orig_ref_action_buttons_sel = "##{dom_id(orig_ref_node, 'item-content')} > .manipulate.buttons"
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.remove node_sel
          page.insert_html insert_pos, orig_ref_sel, render_cell(cell_for_node(@node), :show, :node => @node)
          page.replace orig_ref_action_buttons_sel, :partial => 'action_buttons', :locals => {:item => orig_ref_node}
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
    
    node_sel = dom_id(@node, 'item')
    
    orig_left_action_buttons_sel = "##{dom_id(orig_left_node, 'item-content')} > .manipulate.buttons" unless orig_left_node.nil?
    orig_right_action_buttons_sel = "##{dom_id(orig_right_node, 'item-content')} > .manipulate.buttons" unless orig_right_node.nil?
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.remove node_sel
          page.replace orig_left_action_buttons_sel, :partial => 'action_buttons', :locals => {:item => orig_left_node} unless orig_left_node.nil?
          page.replace orig_right_action_buttons_sel, :partial => 'action_buttons', :locals => {:item => orig_right_node} unless orig_right_node.nil?
        end
      end # format.js
    end # respond_to
  end
  
end
