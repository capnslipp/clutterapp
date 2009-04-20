class TimeProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node
end
