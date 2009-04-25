class NoteProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node
  
  def self.rand
    new :note => String.rand_lorem(50)
  end
end
