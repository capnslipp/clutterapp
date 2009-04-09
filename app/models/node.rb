class Node < ActiveRecord::Base
  acts_as_nested_set
  
  belongs_to :prop, :polymorphic => true
  
  has_one :pile, :foreign_key => 'root_node_id'
  
  
  validates_presence_of :prop
end
