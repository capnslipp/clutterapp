class NodeCell < Cell::Base
  include NodesHelper
  helper_method NodesHelper.public_instance_methods
  
  def show_item
    @node = @opts[:node]
    @children = @node.children || []
    @prop = @node.prop
    
    nil
  end
end