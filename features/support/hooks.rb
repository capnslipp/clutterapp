
require 'dataset'

Cucumber::Rails::World.class_eval do
  include Dataset
  datasets_directory "#{RAILS_ROOT}/test/datasets"
  self.datasets_database_dump_path = "#{RAILS_ROOT}/tmp/dataset"
  
  dataset :users
end
