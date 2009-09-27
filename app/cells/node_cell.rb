class NodeCell < Cell::Base
  helper :cell
  helper :route
  
  cache :show, :cache_version
  
  
  def cache_version
    {
      :node_id => @opts[:node].id,
      :version => @opts[:node].version
    }
  end
  
  
  def show
    @pile = @opts[:pile]
    @node = @opts[:node]
    
    #@children = @node.children || [] # unused
    @prop = @node.prop
    
    render :layout => 'item'
  end
  
  
  # this new action works like "show" because the node has already been created at this point
  def new
    @pile = @opts[:pile]
    @node = @opts[:node]
    
    #@prop = new_prop
    #@node = Node.new(:prop => @prop)
    @prop = @node.prop
    
    render :layout => 'item'
  end
  
  
  def edit
    @pile = @opts[:pile]
    @node = @opts[:node]
    
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
  
  
protected
  
  # must override in each derived Cell type
  def new_prop
    nil # @pile.build_..._prop OR ...Prop.new(:pile => @pile)
  end
  
end
