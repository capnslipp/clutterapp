class NodeCell < Cell::Base
  helper :cell
  
  
  # call cache in each derived class, not this one
  def cache_version
    {
      :owner_id => @opts[:node].pile.owner.id,
      :pile_id => @opts[:node].pile.id,
      :node_id => @opts[:node].id,
      :version => @opts[:node].version
    }
  end
  
  
  def show
    logger.prefixed self.class.to_s, :light_blue, state_name
    fetch_opts
    
    fetch_badges
    
    render :view => 'show', :layout => 'body'
  end
  
  
  def show_badge
    logger.prefixed self.class.to_s, :light_blue, state_name
    fetch_opts
    
    render :view => 'show', :layout => nil
  end
  
  
  def new
    logger.prefixed self.class.to_s, :light_blue, state_name
    fetch_opts
    
    render :view => 'new', :layout => 'item'
  end
  
  
  def create
    logger.prefixed self.class.to_s, :light_blue, state_name
    fetch_opts
    
    render :view => 'show', :layout => 'item'
  end
  
  
  def edit
    logger.prefixed self.class.to_s, :light_blue, state_name
    fetch_opts
    
    fetch_badges
    
    render :view => 'edit', :layout => 'body'
  end
  
  
  def edit_badge
    logger.prefixed self.class.to_s, :light_blue, state_name
    fetch_opts
    
    render :view => 'edit', :layout => nil
  end
  
  
  def update
    logger.prefixed self.class.to_s, :light_blue, state_name
    fetch_opts
    
    fetch_badges
    
    render :view => 'show', :layout => 'body'
  end
  
  
protected
  
  # must override in each derived Cell type
  def new_prop
    nil # @pile.build_..._prop OR ...Prop.new(:pile => @pile)
  end
  
  
  def fetch_opts
    [:node].each do |opt_name|
      instance_variable_set(:"@#{opt_name}", @opts[opt_name])
    end
  end
  
  
  def fetch_badges
    if @node.prop.class.nodeable?
      Prop.badgeable_types.each do |t|
        short_name = t.short_name
        if t.stackable?
          instance_variable_set(:"@#{short_name.pluralize}", @node.children.typed(short_name)) # i.e. @tags
        else
          instance_variable_set(:"@#{short_name}", @node.children.typed(short_name).first) # i.e. @check, @priority, @time
        end
      end
      @check = @node.children.typed(:check).first
    end
  end
  
end
