module CellHelper
  
  def cell_for_node(node)
    cell = /(.+)Prop/.match( node.prop.class.to_s )
    ((cell ? cell[1] : '') + 'Node').underscore.to_sym
  end
  
  def render_child_node(action_view, child_node)
    action_view.render_cell(cell_for_node(child_node), :show, :node => child_node)
  end
  
  def render_node_cell_layout(cell_view, &block)
    cell_view.render(
      :layout => 'nodes/item',
      :object => cell_view.assigns['node'],
      :locals => {
        :render_child => proc {|child_node|
          cell_view.render_cell(cell_for_node(child_node), :show, :node => child_node)
        }
      },
      &block
    )
  end
  
  def link_to_create_node(action_view, parent_node_id, type, update_dom_id)
    type = type.to_s
    action_view.link_to_remote %{<span class="sym">&#10010;</span>#{type}},
      :update => update_dom_id,
      :position => :before,
      :url => {:action => 'create', :controller => 'nodes', :parent_id => parent_node_id, :type => type},
      :method => :post
  end
  
  def create_pile_node_path(action_view, item, type)
    action_view.url_for :action => 'create', :controller => 'nodes', :pile_id => item.pile, :parent_id => item, :type => type
  end
  
end
