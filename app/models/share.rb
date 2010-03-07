class Share < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user
  
  belongs_to :pile
  validates_presence_of :pile
end
