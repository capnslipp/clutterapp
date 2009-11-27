class Share < ActiveRecord::Base
  belongs_to :user
  belongs_to :shared_pile, :class_name => "Pile", :foreign_key => "shared_pile_id"
  validates_presence_of :user
  validates_presence_of :shared_pile
  
end
