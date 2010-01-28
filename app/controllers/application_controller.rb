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
  
  
  def active_owner
    @active_owner
  end
  
  def has_owner?
    @active_owner != nil
  end
  
  
  def active_pile
    @active_pile
  end
  
  def has_pile?
    @active_pile != nil
  end
  
  
protected
  
  def be_xhr_request
    render :nothing => true, :status => :bad_request unless request.xhr?
  end
  
  
  def authorize
    redirect_to login_url unless current_user
  end
  
  def be_visiting
    redirect_to home_url if current_user
  end
  
  
  def have_owner
    return if @active_owner
    
    owner_id = params[:user_id]
    owner_id ||= params[:id] if controller_name == 'users'
    
    if owner_id.nil?
      flash[:error] = "No user_id specified."
      redirect_to user_path(current_user)
      
    else
      @active_owner = User.find_by_login(owner_id)
      
      if @active_owner.nil?
        flash[:warning] = "No such user exists."
        redirect_to user_path(current_user)
      elsif @active_owner != current_user
        flash[:warning] = "You can't really see this pile since it's not yours."
        redirect_to user_path(current_user)
      end
      
    end
  end
  
  
  def have_pile
    return if @active_pile
    
    pile_id = params[:pile_id]
    pile_id ||= params[:id] if controller_name == 'piles'
    
    if pile_id.nil?
      flash[:error] = "No pile_id specified."
      redirect_to polymorphic_path([active_owner, :piles])
    else
      @active_pile = active_owner.piles.find(pile_id)
      
      if @active_pile.nil?
        flash[:warning] = "No such pile exists."
        redirect_to polymorphic_path([active_owner, :piles])
      elsif @active_pile.owner != current_user
        # @todo: check if the user is authorized to view and/or edit this pile
      end
      
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
