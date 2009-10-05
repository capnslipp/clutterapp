class CheckProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node
  
  
  is_badgeable
  
  
  def self::rand_new
    new :checked => (Kernel.rand(2) == 1)
  end
  
  def self::filler_new
    new :checked => false
  end
  
end
