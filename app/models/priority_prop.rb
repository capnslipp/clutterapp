class PriorityProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node
  
  validate :in_range
  
  
  def self::rand
    new :priority => Kernel.rand(5 + 1)
  end
  
  def self::filler
    new :priority => 1
  end
  
  
  def self::badgable?
    true
  end
  
  
protected
  
  def in_range
    errors.add(:priority, "must be in the range of 1 to 5") unless (1..5).include? priority
  end
  
end
