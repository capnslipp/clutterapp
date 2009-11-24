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
  # update      » @mode => :body
  # show        » @mode => :body
  # show_badge  » @mode => :badge
  def show
    fetch_opts
    fetch_badges unless @mode == :badge
    
    render :layout => determine_layout(:show)
  end
  
  
  # new         » @mode => :item
  def new
    fetch_opts
    
    render :layout => determine_layout(:new)
  end
  
  
  # edit        » @mode => :body
  # edit_badge  » @mode => :badge
  def edit
    fetch_opts
    fetch_badges unless @mode == :badge
    
    render :layout => determine_layout(:edit)
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
    
    @mode = @mode.to_sym unless @mode.nil?
  end
  
  
  def determine_layout(state_name)
    case @mode
      when :item:   "item_#{state_name}"
      when :body:   "body_#{state_name}"
      when :badge:  "badge_#{state_name}"
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
