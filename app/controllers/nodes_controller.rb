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
    expire_cache_for(@node)
    
    
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
          #@node.children.create(child_attrs.merge(
          #  :parent => @node,
          #  :pile => @node.pile
          #))
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
    
    
    render :partial => node_body_partial(:edit), :locals => {:node => @node}
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
      expire_cache_for(@node)
      render :partial => node_body_partial(:show), :locals => {:node => @node}
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
    @node.move_to_child_of(@parent)
    
    expire_cache_for(@parent) # new parent
    
    @cell_state = :show
    render :partial => 'list_items', :locals => {:item => @parent}
  end
  
  
  # DELETE /nodes/1
  # DELETE /nodes/1.xml
  def destroy
    @node = active_pile.nodes.find(params[:id])
    orig_parent_node = @node.parent
    @node.destroy
    
    expire_cache_for(@node)
    
    orig_parent_node.after_child_destroy
    
    render :nothing => true, :status => :accepted
  end
  
  
private
  
  def expire_cache_for(record)
    record = record.node if record.is_a? Prop
    
    logger.prefixed 'NodesController#expire_cache_for', :light_yellow, "cache invalidated for Node ##{record.id}"
    
    expire_fragment ({:node_list => record.id}.to_json)
    
    expire_cache_for(record.parent) if record.parent # recursively invalidate all ancestors
  end
  
end
