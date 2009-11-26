require 'ostruct'

module App
  Config = OpenStruct.new
end


App::Config.debug_style = true
#App::Config.debug_style = (ENV['RAILS_ENV'] == 'development')
