class NodeCell < Cell::Base
  include NodesHelper
  helper_method NodesHelper.public_instance_methods
  
  
  #include ActionView::Helpers::CaptureHelper
  #include ActionView::Helpers::TagHelper
  #include ActionView::Helpers::TextHelper
  
  
  def show_item
    @node = @opts[:node]
    @children = @node.children || []
    @prop = @node.prop
    
    controller.append_view_path 'views/nodes'
    
    nil
  end
end