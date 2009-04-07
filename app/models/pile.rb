class Pile < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  validates_presence_of   :owner_id, :message => 'is required'
  
  belongs_to :root_node, :class_name => 'Node'
  validates_presence_of   :root_node_id, :message => 'is required'
end
