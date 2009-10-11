class NodeCell < Cell::Base
  helper :cell
  helper :route
  
  
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
    
    #@pile = @opts[:pile]
    #raise ArgumentError, ":pile option is required by NodeCell#show" if @pile.nil?
    @node = @opts[:node]
    raise ArgumentError, ":node option is required by NodeCell#show" if @node.nil?
    
    #@children = @node.children || [] # unused
    
    if @node.prop.class.nodeable?
      Prop.badgeable_types.each do |t|
        short_name = t.to_s(:short)
        if t.stackable?
          instance_variable_set(:"@#{short_name.pluralize}", @node.children.typed(short_name)) # i.e. @tags
        else
          instance_variable_set(:"@#{short_name}", @node.children.typed(short_name).first) # i.e. @check, @priority, @time
        end
      end
      @check = @node.children.typed(:check).first
    end
    
    render :layout => 'item'
  end
  
  
  def badge
    @node = @opts[:node]
    raise ArgumentError, ":node option is required by NodeCell#show" if @node.nil?
    
    render :layout => nil
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
