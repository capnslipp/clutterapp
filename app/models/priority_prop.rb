class PriorityProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node, :on => :update # less stringent when the Prop is new in order to prevent circular dependencies
  
  validates_presence_of :priority
  validate :priority_in_range
  prop_value_field :priority
  
  
  is_badgeable
  
  
  def self::rand_new
    new :priority => Kernel.rand(5) + 1
  end
  
  def self::filler_new
    new :priority => 1
  end
  
  
protected
  
  def priority_in_range
    errors.add(:priority, "was {{value}}; must be in the range of 1 to 5") unless (1..5).include? priority
  end
  
end
