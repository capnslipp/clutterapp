class PileRefProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node
  validates_presence_of :ref_pile
  
  
  is_stackable
  
  
  #def self::rand_new
  #end
  
  def self::filler_new(owner)
    new :ref_pile => Pile.build(:owner => owner)
  end
  
end
