# FrontController is for front-end stuff that a visitor sees when they're not logged in

class FrontController < ApplicationController
  before_filter :be_visiting
  
  def index
  end
  
end
