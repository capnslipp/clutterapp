module CellHelper
  
  def render_child(child_node)
    render_cell cell_for_node(child_node), :show, :node => child_node
  end
  
  
  def cell_for_node(node)
    cell = /(.+)Prop/.match( node.prop.class.to_s )
    ((cell ? cell[1] : '') + 'Node').underscore.to_sym
  end
  
  
  # probably not working any more
  #def link_to_create_node(action_view, parent_node_id, type, update_dom_id)
  #  type = type.to_s
  #  action_view.link_to_remote %{<span class="sym">&#10010;</span>#{type}},
  #    :update => update_dom_id,
  #    :position => :before,
  #    :url => {:action => 'create', :controller => 'nodes', :parent_id => parent_node_id, :type => type},
  #    :method => :post
  #end
  
  
  def create_pile_node_path(item, type)
    url_for :action => 'create', :controller => 'nodes', :pile_id => item.pile, :parent_id => item, :type => type
  end
  
  
  def css_color_for_priority(priority)
    case priority 
      when 1: '#c30'
      when 2: '#960'
      when 3: '#990'
      when 4: '#390'
      when 5: '#069'
      else    '#666'
    end
  end
  
end
