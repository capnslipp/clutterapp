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
  
  
  # create      » @mode => :item
  # show_badge  » @mode => :badge
  # update      » @mode => :body
  # show        » @mode => :body
  def show
    fetch_opts
    
    fetch_badges unless @mode == :badge
    
    layout = determine_layout
    
    render :view => 'show', :layout => layout unless layout.nil?
  end
  
  
  # new         » @mode => :item
  def new
    fetch_opts
    
    layout = determine_layout
    
    render :view => 'new', :layout => layout unless layout.nil?
  end
  
  
  # edit_badge  » @mode => :badge
  # edit        » @mode => :body
  def edit
    fetch_opts
    
    fetch_badges unless @mode == :badge
    
    layout = determine_layout
    
    render :view => 'edit', :layout => layout unless layout.nil?
  end
  
  
protected
  
  # must override in each derived Cell type
  def new_prop
    nil # @pile.build_..._prop OR ...Prop.new(:pile => @pile)
  end
  
  
  def fetch_opts
    [:node, :mode].each do |opt_name|
      instance_variable_set(:"@#{opt_name}", @opts[opt_name])
    end
    
    @mode = @mode.to_sym
  end
  
  
  def determine_layout
    case @mode
      when :item: 'item'
      when :body: 'body'
      when :badge:  'badge'
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
