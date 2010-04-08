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
  
  
  def subscope(subscope, &block)
    raise ArgumentError.new("subscope must be present") unless subscope.present?
    
    @subscope_stack ||= []
    @subscope_stack.push(subscope)
    
    block.call
    
    @subscope_stack.pop
  end
  
  def current_subscope
    @subscope_stack.last
  end
  
  def subscope_of(pile, user = current_user)
    # first, check for direct modifiability/observability
    if pile.modifiable_publicly?(false) || (pile.modifiable_by_user?(user, false) if user)
      :modifiable
    elsif pile.observable_publicly?(false) || (pile.observable_by_user?(user, false) if user)
      :observable
    # if neither of those were set, check for inherited modifiability/observability
    elsif pile.modifiable_publicly?(true) || (pile.modifiable_by_user?(user, true) if user)
      :modifiable
    elsif pile.observable_publicly?(true) || (pile.observable_by_user?(user, true) if user)
      :observable
    end
  end
  
  
end
