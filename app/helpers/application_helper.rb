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
  
  
  def node_body_partial(state)
    "nodes/#{state}_body"
  end
  
  
  def prop_partial(node, state)
    "props/#{node.prop.class.short_name.underscore}/#{state}"
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
