module NodesHelper
  def cell_for_node(node)
    cell = /(.+)Prop/.match( node.prop.class.to_s )
    ((cell ? cell[1] : '') + 'Node').underscore.to_sym
  end
  
  def render_child_node(view, child_node)
    view.render_cell(cell_for_node(child_node), :show_item, :node => child_node)
  end
  
  def render_node_cell_layout(cell_view, &block)
    cell_view.render(
      :layout => '../views/nodes/item',
      :object => cell_view.assigns['node'],
      :locals => {
        :render_child => proc {|child_node|
          cell_view.render_cell(cell_for_node(child_node), :show_item, :node => child_node)
        }
      },
      &block
    )
  end
end
