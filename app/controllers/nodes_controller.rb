#require "#{RAILS_ROOT}/app/sweepers/node_sweeper.rb"

class NodesController < ApplicationController
  include ERB::Util
  include ApplicationHelper
  layout nil
  
  #cache_sweeper :node_sweeper, :only => [:update_check_prop_checked, :create, :update, :reorder, :reparent, :destroy] # every action but :new and :edit
  
  before_filter :no_cache
  before_filter :be_xhr_request
  before_filter :be_logged_in
  before_filter :have_owner, :have_pile
  before_filter :have_modify_access
  before_filter :have_access, :only => [:sub_pile]
  before_filter :have_modify_access, :except => [:sub_pile]
  
  
  # PUT /nodes/1/update_check_prop_checked
  def update_check_prop_checked
    logger.prefixed 'update_check_prop_checked', :light_green, 'params: ' + params.inspect
    @node = active_pile.nodes.find(params[:id], :include => :prop)
    @prop = @node.prop
    @prop.update_attributes! :checked => params[:checked]
    expire_cache_for(@prop)
    
    render :update do |page|
      page.call 'updateCheckPropField', "check_prop_#{@prop.id}", @prop.checked?
    end
  end
  
  
  # PUT /nodes/1/sub_pile
  def sub_pile
    logger.prefixed 'sub_pile', :light_green, 'params: ' + params.inspect
    @node = active_pile.nodes.find(params[:id], :include => {:prop => :ref_pile})
    @node.prop.ref_pile.update_attributes! :expanded => params[:expanded]
    
    # @note: totally inefficient; invalidates tons of caches up the tree; will never work for one-big-pile approach
    #   solution: render each sub-Pile independently with placeholder, then assemble them 
    expire_cache_for(@node)
    
    if @node.prop.ref_pile.expanded? # if we just expanded it
      subscope subscope_of(@node.prop.ref_pile) do
        render :partial => 'list_items', :locals => {:item => @node.prop.ref_pile.root_node}
      end
    else # if we just collapsed it
      render :nothing => true, :status => :accepted
    end
  end
  
  
  # GET /nodes/new
  # GET /nodes/new?prev_sibling_id=2
  def new
    node_attrs = params.delete(:node) || {}
    
    @parent = active_pile.nodes.find(node_attrs.delete(:parent_id), :include => :pile)
    node_attrs[:pile] = @parent.pile
    
    raise 'node[prop_type] param is required' if node_attrs[:prop_type].nil?
    node_attrs[:prop_attributes] ||= {}
    node_attrs[:prop_attributes][:variant_name] = node_attrs.delete(:prop_type)
    
    @node = @parent.children.build(node_attrs)
    
    # build a sub-pile if the type is a RefPile
    @node.prop.ref_pile = active_owner.piles.build(node_attrs[:prop_attributes][:ref_pile_attributes]) if @node.variant == PileRefProp
    
    
    @prev_sibling = @parent.children.find(params[:prev_sibling_id], :include => :children) if params[:prev_sibling_id].present?
    
    
    add_attrs = []
    
    if params[:dup_prev].present?
      @prev_sibling.children.badgeable.each do |badge_node|
        add_attrs << {:prop_type => badge_node.variant}
      end
    end
    
    add_attrs << params.delete(:add) if params[:add]
    
    add_attrs.each do |add_attr|
      raise 'add[prop_type] param is required' if add_attr[:prop_type].nil?
      add_attr[:prop_attributes] ||= {}
      add_attr[:prop_attributes][:variant_name] = add_attr.delete(:prop_type)
      
      @node.children.build add_attr
    end
    
    
    subscope :modifiable do
      render :partial => 'new_item', :locals => {:item => @node}
    end
  end
  
  
  # POST /nodes
  # POST /nodes?prev_sibling_id=2
  def create
    node_attrs = params.delete(:node) || {}
    
    @parent = active_pile.nodes.find(node_attrs.delete(:parent_id))
    node_attrs[:pile] = @parent.pile
    
    raise 'node[prop_type] param is required' if node_attrs[:prop_type].nil?
    node_attrs[:prop_attributes] ||= {}
    node_attrs[:prop_attributes][:variant_name] = node_attrs.delete(:prop_type)
    
    @node = @parent.children.build(node_attrs)
    
    @node.children.each do |child|
      child.parent = @node
      child.pile = @node.pile
    end
    
    # build a sub-pile if the type is a RefPile
    @node.prop.ref_pile = (active_owner.piles.build node_attrs[:prop_attributes][:ref_pile_attributes]) if @node.variant == PileRefProp
    
    
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
      
      subscope :modifiable do
        if @node.prop.is_a? PileRefProp
          render :partial => 'sub_pile_item', :object => @node
        else
          render :partial => 'show_item', :locals => {:item => @node}
        end
      end
    else
      render :nothing => true, :status => :bad_request
    end
  end
  
  
  # GET /nodes/1/edit
  def edit
    @node = active_pile.nodes.find(params[:id], :include => [:prop, {:children => :prop}])
    
    @node.attributes = params[:node]
    
    
    if params[:add]
      add_attrs = params.delete(:add)
      
      raise 'add[prop_type] param is required' if add_attrs[:prop_type].nil?
      add_attrs[:prop_attributes] ||= {}
      add_attrs[:prop_attributes][:variant_name] = add_attrs.delete(:prop_type)
      
      @node.children.build(add_attrs)
    end
    
    
    subscope :modifiable do
      render :partial => 'edit_body', :locals => {:node => @node}
    end
  end
  
  
  # PUT /nodes/1
  def update
    @node = active_pile.nodes.find(params[:id], :include => [:prop, :parent])
    
    @node.update_attributes(params[:node])
    
    
    subscope :modifiable do
      if @node.save
        expire_cache_for(@node)
        expire_cache_for(@node.prop.ref_pile.root_node) if @node.prop.is_a? PileRefProp
        render :partial => 'show_body', :locals => {:node => @node}
      else
        render :nothing => true, :status => :bad_request
      end
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
    @node = active_pile.nodes.find(params[:id], :include => [:parent, :prop])
    
    expire_cache_for(@node.parent) # old parent
    
    # put it as the first child of the parent
    if params[:target_pile_id].to_i == active_pile.id
      @target = active_pile.nodes.find(params[:target_id], :include => :prop)
      
      unless @node.prop.class.deepable?
        return render(:nothing => true, :status => :bad_request) unless @target.root? || (@target.prop.is_a? PileRefProp)
      end
      
      first_child = @target.children.first
      first_child = first_child.right_sibling if first_child == @node
      if first_child
        @node.move_to_left_of first_child
      else
        @node.move_to_child_of @target
      end
    else
      target_pile = active_owner.piles.find(params[:target_pile_id])
      @target = target_pile.nodes.find(params[:target_id], :include => [:prop, :pile])
      
      unless @node.prop.class.deepable?
        return render(:nothing => true, :status => :bad_request) unless @target.root? || (@target.prop.is_a? PileRefProp)
      end
      
      Node.transaction do
        # deep-duplicate the node into the new tree
        @new_node = deep_clone_node_to_pile!(@node, @target.pile, @target)
        
        # delete it from the old tree
        @node.destroy
      end
    end
    
    expire_cache_for(@target) # new parent
    
    subscope :modifiable do
      render :partial => 'list_items', :locals => {:item => @target}
    end
  end
  
  
  # DELETE /nodes/1
  # DELETE /nodes/1.xml
  def destroy
    @node = active_pile.nodes.find(params[:id], :include => :parent)
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
    if record.root?
      expire_fragment ({:node_section => record.id}.to_json)
      expire_fragment ({:base_node_section => record.id}.to_json)
    end
    
    # recursively invalidate all ancestors
    expire_cache_for(record.parent) if record.parent
    
    # invalidate the cache for any pile ref nodes point at this pile's root node
    if record.root?
      pr = record.pile.pile_ref_prop
      expire_cache_for(pr.node) if pr
    end
    # @note: This is a temporary hack; this approach is not even close to fast enough for all items to be parented by one "master Pile".
    #   Rather, the correct and eventual solution is to track which sub-piles are expanded or collapsed and fetch and render each expanded decendent Pile into a content placeholder in it's parent Pile's fragment cache.
    #   (probably using something like: http://github.com/tylerkovacs/extended_fragment_cache)
  end
  
  def deep_clone_node_to_pile!(orig_node, dest_pile, dest_parent)
    cloned_node = orig_node.clone
    cloned_node.prop = orig_node.prop.clone
    orig_node.prop.ref_pile = nil if orig_node.prop.is_a? PileRefProp # to avoid destroying the dependency
    cloned_node.pile = dest_pile
    dest_parent.children << cloned_node # saves as a side-effect
    
    first_child = dest_parent.children.first
    cloned_node.move_to_left_of first_child unless cloned_node == first_child
    
    # need to add them in reverse order one-by-one so they retain the same ordering
    orig_node.children.reverse_each do |onc|
      deep_clone_node_to_pile!(onc, dest_pile, cloned_node)
    end
    
    cloned_node
  end
  
end
