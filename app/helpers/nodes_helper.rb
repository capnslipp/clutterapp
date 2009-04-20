module NodesHelper
  def cell_for_node(node)
    cell = /(.+)Prop/.match( node.prop.class.to_s )
    ((cell ? cell[1] : '') + 'Node').underscore.to_sym
  end
  
  def node_cell_with_content(content)
    out = ''
    out << <<-EOD
<li class="main-item">
	<div class="body">
		<div class="manipulate buttons shadowable">
			<div class="shadow"></div>
			<a href="#" class="sym">&#10006;</a>
			<a href="#" class="sym">&#9668;</a>
			<a href="#" class="sym">&#9650;</a>
			<a href="#" class="sym">&#9660;</a>
			<a href="#" class="sym">&#9658;</a>
			<a href="#" class="sym">&#9673;</a>
		</div>
		#{content}
	</div>
    EOD
    
    unless @node.children.empty?
      out << '<ul class="main-list">'
      @node.children.each do |child|
        cell = Cell::Base.create_cell_for(@controller, cell_for_node(child), :node => child)
        out << cell.render_state(:show_item)
      end
      out << '</ul>'
    end
    
    out << <<-EOD
	<div class="new buttons shadowable">
		<div class="shadow"></div>
		<a href="#"><span class="sym">&#10010;</span>text</a>
		<a href="#"><span class="sym">&#10010;</span></span>check</a>
		<a href="#"><span class="sym">&#10010;</span></span>note</a>
		<a href="#"><span class="sym">&#10010;</span></span>priority</a>
		<a href="#"><span class="sym">&#10010;</span></span>tag</a>
		<a href="#"><span class="sym">&#10010;</span></span>time</a>
	</div>
</li>
    EOD
  end
end
