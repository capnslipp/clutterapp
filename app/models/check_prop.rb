class CheckProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node
  
  
  is_badgeable; is_stackable
  
  
  def self::rand
    new :checked => (Kernel.rand(2) == 1)
  end
  
  def self::filler
    new :checked => false
  end
  
end
