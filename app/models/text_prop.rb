class TextProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node
  validates_length_of :text, :within => 1..255
end
