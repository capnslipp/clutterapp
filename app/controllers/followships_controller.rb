class FollowshipsController < ApplicationController
  before_filter :authorize

  def toggle_follow
    @user = User.find_by_login(params[:login])
    if @user.is_followee? current_user
      flash[:notice] = "You are no longer following #{@user.login}"
      current_user.unfollow(@user)
    else
      flash[:notice] - "You are now following #{@user.login}"
      current_user.unfollow(@user)
    end
    redirect_to followship_path
  end
  
end
