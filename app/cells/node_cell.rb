class NodeCell < Cell::Base
  def show
    @node = @opts[:node]
    @children = @node.children
    nil
  end
end
