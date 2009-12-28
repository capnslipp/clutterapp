#require "#{RAILS_ROOT}/app/sweepers/node_sweeper.rb"

class NodesController < ApplicationController
  include ERB::Util
  include ApplicationHelper
  layout nil
  
  #cache_sweeper :node_sweeper, :only => [:update_check_prop_checked, :create, :update, :reorder, :reparent, :destroy] # every action but :new and :edit
  
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
    expire_cache_for(@prop)
    
    render :update do |page|
      page.call 'updateCheckPropField', "check_prop_#{@prop.id}", @prop.checked?
    end
  end
  
  
  # GET /nodes/new
  # GET /nodes/new?prev_sibling_id=2
  def new
    node_attrs = params.delete(:node) || {}
    
    @parent = active_pile.nodes.find(node_attrs.delete(:parent_id))
    node_attrs[:pile] = @parent.pile
    
    raise 'node[prop_type] param is required' if node_attrs[:prop_type].nil?
    node_attrs[:prop_attributes] ||= {}
    node_attrs[:prop_attributes][:type] = node_attrs.delete(:prop_type)
    
    @node = @parent.children.build(node_attrs)
    
    
    @prev_sibling = @parent.children.find params[:prev_sibling_id] if params[:prev_sibling_id].present?
    
    
    add_attrs = []
    
    if params[:dup_prev].present?
      @prev_sibling.children.badgeable.each do |badge_node|
        add_attrs << {:prop_type => badge_node.prop.type.short_name}
      end
    end
    
    add_attrs << params.delete(:add) if params[:add]
    
    add_attrs.each do |add_attr|
      raise 'add[prop_type] param is required' if add_attr[:prop_type].nil?
      add_attr[:prop_attributes] ||= {}
      add_attr[:prop_attributes][:type] = add_attr.delete(:prop_type)
      
      @node.children.build add_attr
    end
    
    
    render :partial => 'new_item', :locals => {:item => @node}
  end
  
  
  # POST /nodes
  # POST /nodes?prev_sibling_id=2
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
    
    
    if @node.save!
      if params[:prev_sibling_id].present? # put it after the given sibling
        @prev_sibling = @node.siblings.find params[:prev_sibling_id]
        @node.move_to_right_of @prev_sibling
      else # put it first
        first_child = @parent.children.first
        first_child = first_child.right_sibling if first_child == @node
        
        if first_child # put it before the existing first child
          @node.move_to_left_of first_child
        else # put it under the parent node
          @node.move_to_child_of @parent
        end
      end
      
      
      expire_cache_for(@node)
      render :partial => 'show_item', :locals => {:item => @node}
    else
      render :nothing => true, :status => :bad_request
    end
  end
  
  
  # GET /nodes/1/edit
  def edit
    @node = active_pile.nodes.find(params[:id])
    
    @node.attributes = params[:node]
    
    
    if params[:add]
      add_attrs = params.delete(:add)
      
      raise 'add[prop_type] param is required' if add_attrs[:prop_type].nil?
      add_attrs[:prop_attributes] ||= {}
      add_attrs[:prop_attributes][:type] = add_attrs.delete(:prop_type)
      
      @node.children.build(add_attrs)
    end
    
    
    render :partial => 'edit_body', :locals => {:node => @node}
  end
  
  
  # PUT /nodes/1
  def update
    @node = active_pile.nodes.find(params[:id])
    
    @node.update_attributes(params[:node])
    
    
    if @node.save
      expire_cache_for(@node)
      render :partial => 'show_body', :locals => {:node => @node}
    else
      render :nothing => true, :status => :bad_request
    end
  end
  
  
  # PUT /nodes/1/reorder?prev_sibling_id=2
  def reorder
    @node = active_pile.nodes.find(params[:id])
    
    # put it after the given sibling
    if params[:prev_sibling_id].present?
      @prev_sibling = @node.siblings.find(params[:prev_sibling_id])
      @node.move_to_right_of(@prev_sibling)
      
    # put it first
    else
      @node.move_to_left_of(@node.siblings.first)
    end
    
    expire_cache_for(@node.parent)
    
    render :nothing => true, :status => :accepted
  end
  
  
  # PUT /nodes/1/reparent?parent_id=2
  def reparent
    @node = active_pile.nodes.find(params[:id])
    
    expire_cache_for(@node.parent) # old parent
    
    # put it as the last child of the parent
    @parent = active_pile.nodes.find(params[:parent_id])
    
    first_child = @parent.children.first
    first_child = first_child.right_sibling if first_child == @node
    if first_child
      @node.move_to_left_of first_child
    else
      @node.move_to_child_of @parent
    end
    
    expire_cache_for(@parent) # new parent
    
    render :partial => 'list_items', :locals => {:item => @parent}
  end
  
  
  # DELETE /nodes/1
  # DELETE /nodes/1.xml
  def destroy
    @node = active_pile.nodes.find(params[:id])
    orig_parent_node = @node.parent
    @node.destroy
    
    expire_cache_for(@node)
    
    render :nothing => true, :status => :accepted
  end
  
  
private
  
  def expire_cache_for(record)
    record = record.node if record.is_a? Prop
    
    logger.prefixed 'NodesController#expire_cache_for', :light_yellow, "cache invalidated for Node ##{record.id}"
    
    expire_fragment ({:node_item => record.id}.to_json)
    expire_fragment ({:node_section => record.id}.to_json) if record.root?
    
    expire_cache_for(record.parent) if record.parent # recursively invalidate all ancestors
    # @todo: also invalidate the cache for any pile-ref nodes point at this pile's root node
  end
  
end
