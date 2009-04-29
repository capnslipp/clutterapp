class NodeCell < Cell::Base
  include NodesHelper
  helper_method NodesHelper.public_instance_methods
  
  #include InPlaceEditing
  #in_place_edit_for :text_prop, :text
  helper InPlaceMacrosHelper
  
  def show_item
    @node = @opts[:node]
    @children = @node.children || []
    @prop = @node.prop
  end
  
  #def create
  #  parent = Node.find @opts[:parent_id]
  #  @node = parent.create_child :prop => Prop.rand
  #  
  #  @children = []
  #  @prop = @node.prop
  #end
end