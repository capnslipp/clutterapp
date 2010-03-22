# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def analytics?
     ['production', 'staging'].include?(ENV['RAILS_ENV'])
  end
  
  # @from: <http://pragmatig.wordpress.com/2009/08/26/path_for-rails-helper/>, with fixes
  def path_for(options)
    if options.is_a? Hash
      url_for(options.merge(:only_path => true))
    else
      URI.parse(url_for(options)).path
    end
  end
  
  # @from: <http://lostincode.net/svn/rails_plugins/button_tag/>
  def button_tag(value, options = {})
    options.stringify_keys!
    tag :input, { 'type' => 'button', 'name' => (options[:name] || 'button'), 'value' => value }.merge(options)
  end
  
  
  def prop_partial(node, state)
    raise ArgumentError, "“#{node.inspect}” was passed in for node; a Node was expected" unless node.is_a? Node
    raise ArgumentError, "“#{node.prop.inspect}” was found as the prop for node “#{node.inspect}”; a variant of a Prop was expected" unless node.prop.is_a? Prop
    
    "props/#{node.variant_name}/#{state}"
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
  
  
  # for rendering view partials in sub-scope directories, remembering the current sub-scope (if not explicitly given), and falling back to a "default" sub-scope directory
  # @TODO: refactor this as an alias_method_chain of ActionController's and ActionView's render methods
  def render_subscoped(options = {})
    @subscope_stack ||= []
    @subscope_stack.push(options[:subscope]) if options.has_key?(:subscope)
    raise ArgumentError.new("no subscopes present; make sure at least one is specified with options[:subscope] at the outer-most render_subscoped") if @subscope_stack.empty?
    
    partial_path = options[:partial] || raise(ArgumentError.new(":partial option is required"))
    controller_path = /^([^\/]+)\//.match(partial_path)[1] if partial_path.include?('/')
    controller_path ||= self.is_a?(ActionController::Base) ? self.class.controller_path : controller.class.controller_path
    trimmed_path = partial_path.sub(/^#{controller_path}\//, '')
    
    begin
      # first, try the specific sub-directory
      specific_path = "#{controller_path}/#{current_subscope}/#{trimmed_path}"
      render options.merge({:partial => specific_path})
      
    rescue ActionView::MissingTemplate
      begin
        # next, try the fallback sub-directory
        fallback_path = "#{controller_path}/default/#{trimmed_path}"
        render options.merge({:partial => fallback_path})
        
      rescue ActionView::MissingTemplate
        # last, spit back a custom MissingTemplate message
        raise ActionView::MissingTemplate.new(view_paths, "('#{specific_path}' OR '#{fallback_path}')")
      end
    end
  ensure
    @subscope_stack.pop if options.has_key?(:subscope)
  end
  
  def current_subscope
    @subscope_stack.last
  end
  
  def pile_subscope(pile, user = current_user)
    # first, check for direct modifiability/observability
    if pile.modifiable?(user, false)
      :modifiable
    elsif pile.observable?(user, false)
      :observable
    # if neither of those were set, check for inherited modifiability/observability
    elsif pile.modifiable?(user)
      :modifiable
    elsif pile.observable?(user)
      :observable
    else
      raise ArgumentError.new("pile ##{pile.id} is not accessible by user ##{user.id}")
    end
  end
  
  
end
