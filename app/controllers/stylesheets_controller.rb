class StylesheetsController < ApplicationController
  layout  nil
  
  def show
    name = params[:id]
    
    if name
      render :action => "#{name}.css", :content_type => 'text/css'
    else
      render :nothing => true, :status => 404
    end
  end

end
