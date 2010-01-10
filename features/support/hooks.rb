
require 'dataset'
$__cucumber_toplevel = self # to give Dataset access to Before()
Cucumber::Rails::World.class_eval do
  include Dataset
  datasets_directory "#{RAILS_ROOT}/test/datasets"
  
  dataset :users, :piles
end

include ApplicationHelper
