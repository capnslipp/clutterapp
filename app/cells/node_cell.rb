class NodeCell < Cell::Base
  def show
    @node = @opts[:node]
    @children = @node.children
    @prop = @node.prop
    @prop_type = @prop.class
    nil
  end
end
