class TextProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node, :on => :update # less stringent when the Prop is new in order to prevent circular dependencies
  
  validates_presence_of :text
  validates_length_of :text, :within => 1..255
  
  
  is_stackable
  is_nodeable
  
  
  def self::rand_new
    new :text => String.rand_lorem(5)
  end
  
  def self::filler_new
    new :text => ''
  end
  
end
