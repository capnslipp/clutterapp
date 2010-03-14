class Pile < ActiveRecord::Base
  belongs_to :owner, :class_name => User.name
  validates_presence_of :owner_id, :message => 'is required'
  
  validates_length_of :name, :within => 1..255
  
  has_many :nodes, :dependent => :destroy, :autosave => true
  
  # Shares associations
  has_many :shares
  #has_many :users, :through => :shares
  
  has_many :public_shares
  has_many :specific_user_shares
  
  def shared?
    shares.count > 0
  end
  
  def shared_publicly?
    public_shares.count > 0
  end
  
  def shared_with_specific_users?
    specific_user_shares.count > 0
  end
  
  
  has_one :pile_ref_prop, :foreign_key => 'ref_pile_id'
  
  #validates_presence_of   :root_node, :message => 'is required'
  
  belongs_to :root_node,  :dependent => :destroy, :class_name => 'Node'
  before_validation_on_create :build_root_node
  after_create :save_root_node!
  
  
  def root?
    self.id == self.owner.root_pile_id
  end
  
  def parent
    self.pile_ref_prop && self.pile_ref_prop.node.pile
  end
  
  def children
    @children ||= self.owner.piles.all(:joins => { :pile_ref_prop => :node }, :conditions => ['`nodes`.pile_id = ?', self.id])
  end
  
  def ancestors
    # @todo: optimize
    @ancestors ||= begin
      ancestors = []
      current_ancestor_pile = self
      while !current_ancestor_pile.root?
        current_ancestor_pile = current_ancestor_pile.parent
        ancestors << current_ancestor_pile
      end
      ancestors
    end
  end
  
  
  def share_publicly
    public_shares.create!
  end
  
  def unshare_publicly
    public_shares.destroy
  end
  
  def share_with(user)
    specific_user_shares.create! :sharee => user
  end
  
  def unshare_with(user)
    specific_user_shares(:conditions => {:user => user}).destroy
  end
  
  
  
protected
  
  def build_root_node
    if self.root_node
      logger.warn %[build_root_node attempted for Pile##{self.id} "#{self.name}" when one already exists]
      return
    end
    
    self.root_node = Node.create
  end
  
  def save_root_node!
    self.root_node.pile = self # setting owner afterwards is necessary during creation
    self.root_node.save!
    self.save!
  end
  
end
