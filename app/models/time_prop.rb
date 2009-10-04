class TimeProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node
  
  def self::rand
    new :time => Time.now - Kernel.rand(59).minutes - Kernel.rand(23).hours - Kernel.rand(364).days - Kernel.rand(100).years
  end
  
  def self::filler
    new :time => Time.now
  end
  
  
  def self::badgable?
    true
  end
  
end
