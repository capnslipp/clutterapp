class NodeCell < Cell::Base
  helper :cell
  helper :route
  
  cache :show, :cache_version
  
  
  # not getting cached for some reason
  def cache_version
    {
      :pile_id => @opts[:node].pile.id,
      :node_id => @opts[:node].id,
      :version => @opts[:node].version
    }
  end
  
  
  def show
    logger.prefixed self.class.to_s, :light_blue, "show"
    
    @pile = @opts[:pile]
    @node = @opts[:node]
    
    #@children = @node.children || [] # unused
    
    render :layout => 'item'
  end
  
  
  # this new action works like "show" because the node has already been created at this point
  def new
    logger.prefixed self.class.to_s, :light_blue, "new"
    
    @pile = @opts[:pile]
    @node = @opts[:node]
    
    #@node = Node.new(:prop => new_prop)
    
    render :view => 'edit', :layout => 'item'
  end
  
  
  #def create
  #  parent = Node.find @opts[:parent_id]
  #  @node = parent.create_child :prop => Prop.rand
  #  
  #  @children = []
  #end
  
  
  def edit
    logger.prefixed self.class.to_s, :light_blue, "edit"
    
    @pile = @opts[:pile]
    @node = @opts[:node]
    
    render :layout => nil
  end
  
  
  def update
    logger.prefixed self.class.to_s, :light_blue, "update"
    
    @pile = @opts[:pile]
    @node = @opts[:node]
    
    render :view => 'show', :layout => nil
  end
  
  
protected
  
  # must override in each derived Cell type
  def new_prop
    nil # @pile.build_..._prop OR ...Prop.new(:pile => @pile)
  end
  
end
