class NoteProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node
  
  validates_length_of :note, :minimum => 1
  validates_format_of :note, :with => /\w+/
  
  
  self::stackable = true
  
  
  def self::rand
    new :note => String.rand_lorem(50)
  end
  
  def self::filler
    new :note => ''
  end
end
