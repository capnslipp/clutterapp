class Pile < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  validates_presence_of   :owner_id, :message => 'is required'
  
  belongs_to :root_node, :class_name => 'Node'
  validates_presence_of   :root_node_id, :message => 'is required'
  
  before_validation_on_create :root_node
  
  
  def create_root_node!
    rn = self.create_root_node(:pile => self)
    rn.save! if rn.new_record?
    rn
  end
  
  def root_node
    Node.find_by_id(attributes['root_node_id']) || create_root_node!
  end
  
end
