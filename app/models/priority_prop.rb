class PriorityProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node
  
  def self.rand
    new :priority => Kernel.rand(5 + 1)
  end
end
