require 'ostruct'

module App
  Config = OpenStruct.new
end


App::Config.debug_style = false
#App::Config.debug_style = (ENV['RAILS_ENV'] == 'development')
