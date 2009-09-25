class Pile < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  validates_presence_of   :owner_id, :message => 'is required'
  
  has_many :nodes, :dependent => :destroy, :autosave => true
  
  #validates_presence_of   :root_node, :message => 'is required'
  
  #before_validation_on_create :create_root_node!
  after_create :root_node # ensures that it's created
  
  
  def root_node
    @root_node ||= (nodes.first.root if nodes.first) || create_root_node
  end
  
  
protected
  
  def create_root_node
    @root_node = Node.create(:pile => self) unless nodes.count > 0
  end
  
  def create_root_node!
    raise Exception.new 'A root node could not be created because one for this Pile already exists.' if nodes.count > 0
    create_root_node
  end
  
end
