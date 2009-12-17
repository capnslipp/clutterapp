class NodeSweeper < ActionController::Caching::Sweeper
  observe Node, Prop
  
  # @todo: try these 4 as just an alias_method call
  
  def after_save(record)
    logger.prefixed 'NodeSweeper#after_save', :yellow, "called with: #{record.inspect}"
    expire_cache_for record
  end
  
  def after_create(record)
    logger.prefixed 'NodeSweeper#after_create', :yellow, "called with: #{record.inspect}"
    expire_cache_for record
  end
  
  def after_update(record)
    logger.prefixed 'NodeSweeper#after_update', :yellow, "called with: #{record.inspect}"
    expire_cache_for record
  end
  
  def after_destroy(record)
    logger.prefixed 'NodeSweeper#after_destroy', :yellow, "called with: #{record.inspect}"
    expire_cache_for record
  end
  
  
private
  
  def expire_cache_for(record)
    record = record.node if record.is_a? Prop
    
    logger.prefixed 'Node#increment_version', :light_yellow, "cache invalidated for Node ##{self.id}"
    
    expire_fragment(:key => ['node_item_list', record.id].join(':'))
    
    expire_cache_for(record.parent) if record.parent
  end
  
end
