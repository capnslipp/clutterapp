# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def analytics?
     ['production', 'staging'].include?(ENV['RAILS_ENV'])
  end
  
end
