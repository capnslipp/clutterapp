# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Be sure to include AuthenticationSystem in Application Controller instead (of originally in the UsersController)
  # include AuthenticatedSystem
  
  helper :all # include all helpers, all the time
  helper_method :current_user_session, :current_user
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9dec88372c3d408675df64aed646fffc'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password, :password_confirmation
  
  
  def active_owner_id
    active_owner_id = params[:user_id]
    active_owner_id ||= params[:id] if controller_name == 'users'
    return active_owner_id
  end
  
  def active_owner
    return @active_owner ||= User.find_by_login(active_owner_id)
  end
  
  def active_pile_id
    active_pile_id = params[:pile_id]
    active_pile_id ||= params[:id] if controller_name == 'piles'
    return active_pile_id
  end
  
  def active_pile
    return @active_pile ||= active_owner.piles.find_by_id(active_pile_id)
  end
  
  
protected
  
  def be_xhr_request
    render :nothing => true, :status => :bad_request unless request.xhr?
  end
  
  
  def no_cache
    response.headers['Last-Modified'] = Time.now.httpdate
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
    
    # HTTP 1.0
    response.headers['Pragma'] = 'no-cache'
    
    # HTTP 1.1 ('pre-check=0, post-check=0' IE-specific)
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0, pre-check=0, post-check=0'
  end
  
  
  def be_logged_in
    redirect_to login_url unless current_user
  end
  
  def be_visiting
    redirect_to home_url if current_user
  end
  
  
  def have_owner
    if active_owner_id.nil?
      flash[:error] = "No user specified."
      redirect_to current_user || home_url
    elsif active_owner.nil?
      flash[:error] = "User “#{active_owner_id}” doesn't exist."
      redirect_to current_user || home_url
    else
      return # success
    end
  end
  
  def have_pile
    if active_pile_id.nil?
      flash[:error] = "No pile specified."
      redirect_to [active_owner, :piles]
    elsif active_pile.nil?
      flash[:error] = "Pile “#{active_pile_id}” doesn't exist."
      redirect_to [active_owner, :piles]
    else
      return # success
    end
  end
  
  
  def have_access
    if active_pile.accessible?(current_user)
      return # success
    else
      flash[:warning] = "You do not have access to “#{active_owner_id}”'s pile “#{active_pile_id}”."
      redirect_to current_user || home_url
    end
  end
  
  def have_modify_access
    if active_pile.modifiable?(current_user)
      return # success
    else
      flash[:warning] = "You do not have modify access for “#{active_owner_id}”'s pile “#{active_pile_id}”."
      redirect_to current_user || home_url
    end
  end
  
  
  # helper methods to access authlogic current_user
private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user_session?
    !!current_user_session
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session.user if current_user_session
  end
  
  def current_user?
    !!current_user
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
    end
  end
  
  def require_no_user
    if current_user
      # silent redirect
      redirect_to home_path
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
end
