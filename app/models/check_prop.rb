class CheckProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node
  
  def self.rand
    new :checked => (Kernel.rand(1 + 1) == 1)
  end
end
