# HomeController is for dashboard-ish stuff that a visitor sees when they are logged in

class HomeController < ApplicationController
  before_filter :authorize

  def index
    @user = current_user
    @root_pile = @user.root_pile
  end
  
end
