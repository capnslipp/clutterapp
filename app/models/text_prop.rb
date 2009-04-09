class TextProp < ActiveRecord::Base
  has_one :node, :as => :prop
  
  validates_length_of :text, :within => 1..255
end
