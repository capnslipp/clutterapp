class FollowshipsController < ApplicationController
  before_filter :authorize
  
  def create
  end
  
  def toggle_follow
    @user = User.find_by_id(params[:id])
    
    if current_user.following? @user
      flash[:notice] = "You are no longer following #{@user.login}"
      current_user.unfollow(@user)
    else
      flash[:notice] - "You are now following #{@user.login}"
      current_user.follow(@user)
    end
    redirect_to user_path
  end
  
  def following
    @following = current_user.followees
  end
  
  def followers
    @followers = current_user.followers
  end
  
  def destroy
  end
  
  
end
