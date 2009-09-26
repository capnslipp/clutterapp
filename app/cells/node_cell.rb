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
    @node = @opts[:node]
    @children = @node.children || []
    @prop = @node.prop
    @user = @node.root.pile.owner
    
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
