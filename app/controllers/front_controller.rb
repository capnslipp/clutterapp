# FrontController is for front-end stuff that a visitor sees when they're not logged in

class FrontController < ApplicationController
  
  def index
    @invite = Invite.new
  end
  
end
