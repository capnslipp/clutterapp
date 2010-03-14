## STI base class; not meant to be used directly
class Share < ActiveRecord::Base
  belongs_to :pile
  validates_presence_of :pile
  
end
