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
  
  
  # create      » :mode => :body,  :xhr => true, :parital => :item
  # update      » :mode => :body,  :xhr => true
  # show        » :mode => :body
  # show_badge  » :body => false
  def show
    fetch_opts
    fetch_badges
    
    render
  end
  
  
  # new         » :mode => :body,  :xhr => true, :parital => :item
  def new
    fetch_opts
    
    render
  end
  
  
  # edit        » :mode => :body,  :xhr => true
  # edit_badge  » :body => false, :xhr => true
  def edit
    fetch_opts
    fetch_badges
    
    render
  end
  
  
protected
  
  # must override in each derived Cell type
  def new_prop
    nil # @pile.build_..._prop OR ...Prop.new(:pile => @pile)
  end
  
  
  def fetch_opts
    @node = @opts[:node]
    @form = @opts[:form]
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
