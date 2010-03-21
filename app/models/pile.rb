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
  
  named_scope :shared_publicly, :joins => :public_shares
  
  named_scope :shared_with_user, lambda {|sharee_user|
    { :joins => :specific_user_shares, :conditions => {:shares => {:sharee_id => sharee_user.id}} }
  }
  named_scope :shared_by_user, lambda {|owner_user|
    { :joins => :shares, :conditions => {:piles => {:owner_id => owner_user.id}} }
  }
  
  # helpers for the sharing settings on this Pile (primarily for the owner)
  
  def shared?
    shares.exists?
  end
  
  def shared_publicly?
    public_shares.exists?
  end
  
  def shared_with_specific_users?
    specific_user_shares.exists?
  end
  
  # helpers for permission determination, whether effective or explicitly set
  #   accessible: can access it in any way
  #   observable: can view it in a view-only state; mutually exclusive with modifiable
  #   modifiable: can modify and change it; mutually exclusive with observable
  
  def accessible?(user_or_nil)
    accessible_publicly? || (accessible_by_user?(user_or_nil) if user_or_nil)
  end
  
  def observable?(user_or_nil)
    observable_publicly? || (observable_by_user?(user_or_nil) if user_or_nil)
  end
  
  def modifiable?(user_or_nil)
    modifiable_publicly? || (modifiable_by_user?(user_or_nil) if user_or_nil)
  end
  
  def accessible_publicly?
    public_shares.exists? ||
      (parent.accessible_publicly? if parent)
  end
  
  def observable_publicly?
    public_shares.exists?(:modifiable => false) ||
      (parent.modifiable_publicly? if parent)
  end
  
  def modifiable_publicly?
    public_shares.exists?(:modifiable => true) ||
      (parent.modifiable_publicly? if parent)
  end
  
  def accessible_by_user?(user)
    user == owner ||
      specific_user_shares.exists?(:sharee_id => user.id) ||
      (parent.accessible_by_user?(user) if parent)
  end
  
  def observable_by_user?(user)
    user == owner ||
      specific_user_shares.exists?(:sharee_id => user.id, :modifiable => false) ||
      (parent.accessible_by_user?(user) if parent)
  end
  
  def modifiable_by_user?(user)
    user == owner ||
      specific_user_shares.exists?(:sharee_id => user.id, :modifiable => true) ||
      (parent.modifiable_by_user?(user) if parent)
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
    self.pile_ref_prop.node.pile if self.pile_ref_prop
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
  
  
  SHARE_PUBLICLY_DEFAULT_OPTIONS = { :modifiable => false }
  def share_publicly(options = {})
    options.reverse_merge! SHARE_PUBLICLY_DEFAULT_OPTIONS
    public_shares.create! :modifiable => options[:modifiable]
  end
  
  def unshare_publicly
    public_shares.destroy_all
  end
  
  SHARE_WITH_DEFAULT_OPTIONS = { :modifiable => false }
  def share_with(sharee, options = {})
    options.reverse_merge! SHARE_WITH_DEFAULT_OPTIONS
    specific_user_shares.create! :sharee => sharee, :modifiable => options[:modifiable]
  end
  
  def unshare_with(sharee)
    su_shares = specific_user_shares(:conditions => {:sharee => sharee}).destroy_all
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
