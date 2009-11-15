class NodeCell < Cell::Base
  helper :cell
  
  
  # not getting cached for some reason
  def cache_version
    {
      :owner_id => @opts[:node].pile.owner.id,
      :pile_id => @opts[:node].pile.id,
      :node_id => @opts[:node].id,
      :version => @opts[:node].version
    }
  end
  
  
  def show
    logger.prefixed self.class.to_s, :light_blue, 'show'
    
    @node = @opts[:node]
    
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
    
    render :layout => 'show'
  end
  
  
  def badge
    @node = @opts[:node]
    
    render :layout => nil
  end
  
  
  def new
    logger.prefixed self.class.to_s, :light_blue, 'new'
    
    @node = @opts[:node]
    
    render :layout => 'new'
  end
  
  
  def create
    logger.prefixed self.class.to_s, :light_blue, 'update'
    
    @node = @opts[:node]
    
    render :view => 'show', :layout => 'show'
  end
  
  
  def edit
    logger.prefixed self.class.to_s, :light_blue, 'edit'
    
    @node = @opts[:node]
    
    render :layout => 'edit'
  end
  
  
  def update
    logger.prefixed self.class.to_s, :light_blue, 'update'
    
    @node = @opts[:node]
    
    render :view => 'show', :layout => nil
  end
  
  
protected
  
  # must override in each derived Cell type
  def new_prop
    nil # @pile.build_..._prop OR ...Prop.new(:pile => @pile)
  end
  
end
