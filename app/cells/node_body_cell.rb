class NodeBodyCell < Cell::Base
  helper :cell
  
  
  def show
    @node = @opts[:node]
    
    render
  end
  
  
  def new
    @node = @opts[:node]
    
    render
  end
  
  
  def edit
    @node = @opts[:node]
    
    render
  end
  
end
