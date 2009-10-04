class TagProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node
  validates_length_of :tag, :within => 1..26
  
  def self::rand
    new :tag => String.rand_alphanum(4)
  end
  
  def self::filler
    new :tag => ''
  end
  
  
  def self::badgable?
    true
  end
  
end
