class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
    @user_session.remember_me = true
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    
    if @user_session.save
      flash[:notice] = "Logged in successfully"
      redirect_to home_url
    else
      flash[:notice] = "Login incorrect"
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
  
  private
  # Might be useful once we fix the params
  # def note_failed_signin
  #   flash[:error] = "Couldn't log you in as '#{params[:login]}'"
  #   logger.warn "#{logger.prefix('USER', :light_yellow)}Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  # end
  
end