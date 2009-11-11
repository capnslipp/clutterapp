class TagProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node, :on => :update # less stringent when the Prop is new in order to prevent circular dependencies
  validates_length_of :tag, :within => 1..26
  
  
  #is_badgeable
  is_stackable
  
  
  def self::rand_new
    new :tag => String.rand_alphanum(4)
  end
  
  def self::filler_new
    new :tag => ''
  end
  
end
