# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def analytics?
     ENV['RAILS_ENV'] == 'production'
  end
  
end
