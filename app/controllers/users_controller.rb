class UsersController < ApplicationController
  before_filter :have_owner, :only => [:show]
  before_filter :be_visiting, :only => [:new, :create]
  
  
  def new
    # derived from Railscasts #124: Beta Invites <http://railscasts.com/episodes/124-beta-invites>
    @user = User.new(:invite_token => params[:invite_token])
    @user.email = @user.invite.recipient_email if @user.invite
    @user.password = @user.password_confirmation = nil
    
    render # new.html.erb
  end
  
  
  def create
    @user = User.new(params[:user])
    signup_code_correct = (params[:signup_code] == self.class.current_signup_code)
    
    if signup_code_correct && @user.save
      # Protects against session fixation attacks, causes request forgery protection if visitor resubmits an earlier form using back button. Uncomment if you understand the tradeoffs.
      #reset session
      
      logger.prefixed 'USER', :light_yellow, "New user '#{@user.login}' created from #{request.remote_ip} at #{Time.now.utc}"
      current_user = @user # !! now logged in
      
      flash[:notice] = "Thanks for signing up! Enjoy organizing your clutter!"
      redirect_to home_url
    else
      flash[:error]  = "We couldn't set up that account, sorry. Please try again."
      render :action => 'new'
    end
  end
  
  
  def show
    @user = active_owner
    if @user
      @public_piles = @user.piles.shared_publicly.all
      @piles_shared_with_us = @user.piles.shared_with_user(current_user).all if current_user?
      
      render # show.html.erb
    else
      flash[:error]  = %{Couldn't find user by the name of "#{params[:id]}".}
      redirect_to home_path
    end
  end
  
  
protected
  
  def self::current_signup_code
    today = Date.today
    
    first_letter_of_day_of_week = today.strftime('%A')[0,1]
    last_digit_of_day_of_month = today.strftime('%d')[1,1]
    first_letter_of_month = today.strftime('%b')[0,1]
    last_digit_of_year = today.strftime('%Y')[3,1]
    
    secret_code = first_letter_of_day_of_week + last_digit_of_day_of_month + '-' + first_letter_of_month + last_digit_of_year
    "#{secret_code}"
  end
  
end
