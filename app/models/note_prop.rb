class NoteProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node
  
  validates_length_of :note, :minimum => 1
  validates_format_of :note, :with => /\w+/
  
  
  is_stackable
  
  
  def self::rand_new
    new :note => String.rand_lorem(50)
  end
  
  def self::filler_new
    new :note => ''
  end
end
