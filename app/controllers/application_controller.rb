# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Be sure to include AuthenticationSystem in Application Controller instead (of originally in the UsersController)
  # include AuthenticatedSystem
  
  helper :all # include all helpers, all the time
  helper_method :current_user_session, :current_user_session?, :current_user, :current_user?, :active_owner, :active_owner?, :active_pile, :active_pile?
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9dec88372c3d408675df64aed646fffc'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password, :password_confirmation
  
  
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
    return if current_user?
    
    flash.now[:error] = "You must have an account and be logged in to use this page."
    render_error :log_in_necessary
    return false
  end
  
  def be_visiting
    return unless current_user?
    
    flash.now[:error] = "You must be logged out in order to visit this page."
    render_error :log_out_necessary
    return false
  end
  
  
  def have_owner
    if active_owner_id.nil?
      flash.now[:error] = "No user specified."
      render_error :not_found
      return false
      
    elsif active_owner.nil?
      flash.now[:error] = "User “#{active_owner_id}” doesn't exist."
      render_error :not_found
      return false
      
    else
      return # success
    end
  end
  
  def have_pile
    if active_pile_id.nil?
      flash.now[:error] = "No pile specified."
      render_error :not_found
      return false
      
    elsif active_pile.nil?
      flash.now[:error] = "Pile “#{active_pile_id}” doesn't exist or doesn't belong to “#{active_owner_id}”."
      render_error :not_found
      return false
      
    else
      return # success
    end
  end
  
  
  def have_access
    if active_pile.accessible_publicly? || (active_pile.accessible_by_user?(current_user) if current_user)
      return # success
    else
      flash.now[:error] = "You do not have access to “#{active_owner_id}”'s pile “#{active_pile_id}”."
      render_error :no_access
      return false
    end
  end
  
  def have_modify_access
    if active_pile.modifiable_publicly? || (active_pile.modifiable_by_user?(current_user) if current_user)
      return # success
    else
      flash.now[:error] = "You do not have modify access for “#{active_owner_id}”'s pile “#{active_pile_id}”."
      render_error :no_access
      return false
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
  
  
  def active_owner_id
    active_owner_id = params[:user_id]
    active_owner_id ||= params[:id] if controller_name == 'users'
    return active_owner_id
  end
  
  def active_owner
    return @active_owner ||= User.find_by_login(active_owner_id)
  end
  
  def active_owner?
    !!active_owner
  end
  
  def active_pile_id
    active_pile_id = params[:pile_id]
    active_pile_id ||= params[:id] if controller_name == 'piles'
    return active_pile_id
  end
  
  def active_pile
    return nil unless active_owner?
    return @active_pile ||= active_owner.piles.find_by_id(active_pile_id)
  end
  
  def active_pile?
    !!active_pile
  end
  
  
  def render_error(type)
    type = type.to_sym
    
    # keys are error types, values are HTTP status codes
    types_to_statuses = {
      :not_found =>         :not_found,
      :log_in_necessary =>  :unauthorized,
      :log_out_necessary => :unauthorized,
      :no_access =>         :unauthorized
    }
    
    render :template => "error/#{type}", :layout => 'error', :status => types_to_statuses[type]
  end
  
end
