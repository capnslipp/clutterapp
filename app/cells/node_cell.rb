class NodeCell < Cell::Base
  include NodesHelper
  helper_method NodesHelper.public_instance_methods
  
  
  #include ActionView::Helpers::CaptureHelper
  #include ActionView::Helpers::TagHelper
  #include ActionView::Helpers::TextHelper
  
  
  def show_item
    @node = @opts[:node]
    @children = @node.children
    @prop = @node.prop
        
    #state = 'show_item'
    
    ### DISCUSS: create Cell::View directly? maybe we can fix a gettext problem this way?
    #view_class  = Class.new(Cell::View)
    #action_view = view_class.new(@@view_paths, {}, @controller)
    #action_view.cell = self
    ### FIXME/DISCUSS: 
    #action_view.template_format = :html # otherwise it's set to :js in AJAX context!
    
    # Make helpers and instance vars available
    #include_helpers_in_class(view_class)
    
    #action_view.assigns = assigns_for_view
    
    
    #template = find_family_view_for_state(state, action_view)
    ### TODO: cache family_view for this cell_name/state in production mode,
    ###   so we can save the call to possible_paths_for_state.
    
    #action_view.render(:file => template) 
    
    nil
  end
end