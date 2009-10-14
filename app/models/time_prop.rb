class TimeProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node, :on => :update # less stringent when the Prop is new in order to prevent circular dependencies
  
  
  is_badgeable
  
  
  def self::rand_new
    new :time => Time.now - Kernel.rand(59).minutes - Kernel.rand(23).hours - Kernel.rand(364).days - Kernel.rand(100).years
  end
  
  def self::filler_new
    new :time => Time.now
  end
  
end
