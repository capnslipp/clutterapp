class SpecificUserShare < Share
  belongs_to :sharee, :class_name => User.name
  validates_presence_of :sharee
  validate :sharee_is_not_pile_owner
  
  # share each pile with each "sharee" User at most once
  validates_uniqueness_of :sharee_id, :scope => :pile_id
  validates_uniqueness_of :pile_id, :scope => :sharee_id
  
  protected
  
  def sharee_is_not_pile_owner
    errors.add_to_base("sharing a Pile with its owner is pointless and not allowed") unless pile && pile.owner != sharee
  end
  
  def sharee_by_login
    sharee.login
  end
  
  def sharee_by_login=(login)
    sharee = User.find_by_login(login)
  end
  
end
