# HomeController is for dashboard-ish stuff that a visitor sees when they are logged in

class HomeController < ApplicationController
  before_filter :be_logged_in
  
  def index
    @user = current_user
    
    @root_pile = @user.root_pile
    @recent_piles = @user.piles(:order => 'updated_at DESC', :limit => 10).all
    @piles_shared_with_us = Pile.shared_with_user(@user).all
    @piles_shared_by_us = Pile.shared_by_user(@user).all
  end
  
end
