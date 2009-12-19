class TagProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node, :on => :update # less stringent when the Prop is new in order to prevent circular dependencies
  
  validates_presence_of :tag
  validates_length_of :tag, :within => 1..26
  before_save :normalize_tag
  
  
  is_badgeable
  is_stackable
  
  
  def <=>(other)
    if other.instance_of?(TagProp)
      self.tag.to_s <=> other.tag.to_s
    else
      super(other)
    end
  end
  
  
  def self::rand_new
    new :tag => String.rand_alphanum(4)
  end
  
  def self::filler_new
    new :tag => ''
  end
  
  
private
  
  def normalize_tag
    tag.strip!
    tag.downcase!
  end
  
end
