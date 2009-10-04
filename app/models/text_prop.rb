class TextProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node
  validates_length_of :text, :within => 1..255
  
  
  self::badgeable = true
  self::stackable = true
  self::nodeable = true
  
  
  def self::rand
    new :text => String.rand_lorem(5)
  end
  
  def self::filler
    new :text => ''
  end
  
end
