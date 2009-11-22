class FollowshipsController < ApplicationController
  before_filter :authorize

  def index
    @followees = current_user.followees
#    @users = current_user.users
  end
  
  def create
  end
  
  def toggle_follow
    @user = User.find_by_login(params[:login])
    if current_user.is_followee? @user
      flash[:notice] = "You are no longer following #{@user.login}"
      current_user.unfollow(@user)
    else
      flash[:notice] - "You are now following #{@user.login}"
      current_user.follow(@user)
    end
    redirect_to followship_path
  end
  
  def destroy
  end
  
  
end
