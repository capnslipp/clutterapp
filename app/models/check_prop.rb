class CheckProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node, :on => :update # less stringent when the Prop is new in order to prevent circular dependencies
  
  prop_value_field :checked
  
  
  is_badgeable
  
  
  def self::rand_new
    new :checked => (Kernel.rand(2) == 1)
  end
  
  def self::filler_new
    new :checked => false
  end
  
end
