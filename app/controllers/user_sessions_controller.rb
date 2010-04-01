class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:destroy]
  
  
  def new
    @user_session = UserSession.new(:remember_me => true)
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    
    if @user_session.save
      redirect_to home_url
      
    else
      login = @user_session.login
      
      flash[:error] = "Couldn't log you in as '#{login}'"
      logger.prefixed 'USER', :light_yellow, "Failed login for '#{login}' from #{request.remote_ip} at #{Time.now.utc}"
      render :action => 'new'
    end
  end
  
  def destroy
    current_user_session.destroy
    
    flash[:notice] = "See ya, space cowboy…"
    redirect_to root_url
  end
  
  
protected
  
  def require_user
    return if current_user
    
    # silent redirect
    redirect_to new_user_session_url
  end
  
  def require_no_user
    return unless current_user
    
    # silent redirect
    redirect_to home_path
  end
  
end