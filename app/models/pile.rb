class Pile < ActiveRecord::Base
  belongs_to :owner, :class_name => User.name
  validates_presence_of :owner_id, :message => 'is required'
  
  validates_length_of :name, :within => 1..255
  
  has_many :nodes, :dependent => :destroy, :autosave => true
  
  # Shares associations
  has_many :shares
  has_many :users, :through => :shares
  
  has_one :pile_ref_prop, :foreign_key => 'ref_pile_id'
  
  #validates_presence_of   :root_node, :message => 'is required'
  
  belongs_to :root_node,  :dependent => :destroy, :class_name => 'BaseNode'
  before_validation_on_create :build_root_node
  after_create :save_root_node!
  
  
  named_scope :master, :include => :pile_ref_prop, :conditions => ['`pile_ref_props`.ref_pile_id IS NULL']
  named_scope :nested, :joins => :pile_ref_prop
  
  
protected
  
  def build_root_node
    if self.root_node
      logger.warn %[build_root_node attempted for Pile##{self.id} "#{self.name}" when one already exists]
      return
    end
    
    self.root_node = BaseNode.create
  end
  
  def save_root_node!
    self.root_node.pile = self # setting owner afterwards is necessary during creation
    self.root_node.save!
    self.save!
  end
  
end
