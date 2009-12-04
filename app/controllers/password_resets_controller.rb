class PasswordResetsController < ApplicationController
  before_filter :load_user_with_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  
  def new
  end
  
  def edit
  end
  
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Instruction to reset your password have been emailed to you. Please check your email."
      redirect_to home_path
    else
      flash[:notice] = "No user was found with that email."
      render :action => :new
    end
  end
  
  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = "Password successfully updated."
      redirect_to home_path
    else
      render :action => :edit
    end
  end
  
  private
  
  def load_user_with_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "We're sorry, we could not locate your account. If you are having trouble, try copying and pasting the url into your browser or restarting the reset password process."
      redirect_to home_path
    end
  end
end
