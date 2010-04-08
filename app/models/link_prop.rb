class LinkProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node, :on => :update # less stringent when the Prop is new in order to prevent circular dependencies
  
  validates_presence_of :link
  validates_length_of :link, :within => 1..255
  prop_value_field :link
  
  
  is_stackable
  
  
  def self::rand_new
    new :text => "http://#{String.rand_lorem(5).downcase}/"
  end
  
  def self::filler_new
    new :text => ''
  end
  
end
