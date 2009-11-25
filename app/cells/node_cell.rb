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
    logger.prefixed self.class.to_s, :light_blue, 'show'
    fetch_opts
    
    fetch_badges
    
    render :view => 'show', :layout => 'show_body'
  end
  
  
  def show_badge
    logger.prefixed self.class.to_s, :light_blue, 'show_badge'
    fetch_opts
    
    render :view => 'show', :layout => nil
  end
  
  
  def new
    logger.prefixed self.class.to_s, :light_blue, 'new'
    fetch_opts
    
    render :view => 'new', :layout => 'new_item'
  end
  
  
  def create
    logger.prefixed self.class.to_s, :light_blue, 'create'
    fetch_opts
    
    render :view => 'show', :layout => 'show_item'
  end
  
  
  def edit
    logger.prefixed self.class.to_s, :light_blue, 'edit'
    fetch_opts
    
    fetch_badges
    
    render :view => 'edit', :layout => 'edit_body'
  end
  
  
  def edit_badge
    logger.prefixed self.class.to_s, :light_blue, 'edit_badge'
    fetch_opts
    
    render :view => 'edit', :layout => nil
  end
  
  
  def update
    logger.prefixed self.class.to_s, :light_blue, 'update'
    fetch_opts
    
    fetch_badges
    
    render :view => 'show', :layout => 'show_body'
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
