class Pile < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  validates_presence_of   :owner_id, :message => 'is required'
  
  belongs_to :root_node, :class_name => 'Node'
  validates_presence_of   :root_node_id, :message => 'is required'
  
  before_validation_on_create :create_default_root_node_if_not_exists
  
  protected
  
  def create_default_root_node_if_not_exists
    self.create_root_node unless self.root_node
  end
end
