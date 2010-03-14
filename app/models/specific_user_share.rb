class SpecificUserShare < Share
  belongs_to :sharee, :class_name => User.name
  validates_presence_of :sharee
  
  # share each pile with each "sharee" User at most once
  validates_uniqueness_of :sharee_id, :scope => :pile_id
  validates_uniqueness_of :pile_id, :scope => :sharee_id
  
end
