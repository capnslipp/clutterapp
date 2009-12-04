class Share < ActiveRecord::Base
  belongs_to :user
  belongs_to :pile, :class_name => "Pile", :foreign_key => "shared_pile_id"
  validates_presence_of :user
  validates_presence_of :pile
  
end
