require 'ostruct'

module App
  Config = OpenStruct.new
end


ClutterApp::Config.debug_style = false
#ClutterApp::Config.debug_style = (ENV['RAILS_ENV'] == 'development')
