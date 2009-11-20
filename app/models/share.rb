class Share < ActiveRecord::Base
  validates_presence_of :user
  validates_presence_of :shared_pile
end
