class Followship < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user
  
  belongs_to :followee, :class_name => User.name
  validates_presence_of :followee
  
end
