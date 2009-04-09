class Node < ActiveRecord::Base
  acts_as_nested_set
  
  belongs_to :prop, :polymorphic => true
  
  has_one :pile, :foreign_key => 'root_node_id'
  
  
  validates_presence_of :prop, :unless => :root?
  validates_inclusion_of :root?, :in => [true], :unless => :prop
  validates_inclusion_of :root?, :in => [false], :if => :prop
end
