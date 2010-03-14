class SpecificUserShare < Share
  belongs_to :sharee, :class_name => User.name
  validates_presence_of :sharee
  validates_uniqueness_of :sharee, :scope => 'pile_id' # share each pile with each "sharee" User at most once
  
end
