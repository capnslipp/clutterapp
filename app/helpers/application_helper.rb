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
  
end
