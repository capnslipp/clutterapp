class Pile < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  validates_presence_of   :owner_id, :message => 'is required'
  
  has_many :nodes
  
  validates_presence_of   :root_node, :message => 'is required'
  before_validation_on_create :root_node
  
  
  
  def create_root_node!
    raise Exception.new 'A root node could not be created because 1 or more nodes for this pile already exist.' if nodes.count > 0
    nodes.build
  end
  
  def root_node
    (nodes.first.root unless nodes.first.nil?) || create_root_node!
  end
  
end
