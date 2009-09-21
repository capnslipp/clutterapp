class NodeCell < Cell::Base
  include NodesHelper
  helper_method NodesHelper.public_instance_methods
  
  cache :show_item, :cache_version unless 
  
  def cache_version
    hash = {
      :node_id => @opts[:node].id,
      :version => @opts[:node].version
    }
    #RAILS_DEFAULT_LOGGER.debug(RAILS_DEFAULT_LOGGER.prefix("#{self.class.to_s}#cache_version", 34) + "hash: " + hash.inspect)
    hash
  end
  
  #include InPlaceEditing
  #in_place_edit_for :text_prop, :text
  helper InPlaceMacrosHelper
  
  def show_item
    #RAILS_DEFAULT_LOGGER.debug(RAILS_DEFAULT_LOGGER.prefix("#{self.class.to_s}#show_item", 31) + "state_cached?(:show_item): " + state_cached?(:show_item).inspect)
    
    @node = @opts[:node]
    @children = @node.children || []
    @prop = @node.prop
    
    render
  end
  
  #def create
  #  parent = Node.find @opts[:parent_id]
  #  @node = parent.create_child :prop => Prop.rand
  #  
  #  @children = []
  #  @prop = @node.prop
  #end
end