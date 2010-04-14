class StylesheetsController < ApplicationController
  layout  nil
  
  
  STATIC_STYLESHEET_NAMES = ['reset', 'magic']
  DYNAMIC_STYLESHEET_NAMES = ['main', 'layout', 'button-bars', 'props']
  
  
  def show
    name = params[:id].underscore
    
    begin
      render :partial => "#{name}.css", :content_type => 'text/css'
    rescue ActionView::MissingTemplate
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
    end
  end
  
  
  # Replaces Rail's generated "all" file and renders the "all.css.erb" partial instead,
  # which renders each static file and each dynamic partial listed.
  # Note: public/stylesheets/all.css MUST not be present, as it has first priority over routes.
  def all
    @static_stylesheet_filenames = STATIC_STYLESHEET_NAMES.map {|n| "#{n}.css" }
    @dynamic_stylesheet_partials = DYNAMIC_STYLESHEET_NAMES.map {|n| "#{n.underscore}.css" }
    
    render :action => "all.css", :content_type => 'text/css'
  end
  
end
