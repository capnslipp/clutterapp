class Node < ActiveRecord::Base
  acts_as_nested_set
  
  
  has_one :pile, :foreign_key => 'root_node_id'
end
