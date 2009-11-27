class NodeBodyCell < Cell::Base
  helper :cell
  
  
  def show
    fetch_opts
    fetch_badges
    
    render
  end
  
  
  def new
    fetch_opts
    
    render
  end
  
  
  def edit
    fetch_opts
    fetch_badges
    
    render
  end
  
  
protected
  
  def fetch_opts
    @node = @opts[:node]
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
