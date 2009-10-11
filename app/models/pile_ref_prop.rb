class PileRefProp < Prop
  has_one :node, :as => :prop
  
  belongs_to :ref_pile, :class_name => Pile.to_s
  
  validates_presence_of :node
  validates_presence_of :ref_pile
  
  
  after_create :ensure_ref_pile
  
  
  is_stackable; isnt_deepable
  
  
  #def self::rand_new
  #end
  
  def self::filler_new
    new :ref_pile => Pile.new()
  end
  
  
protected
  
  def ensure_ref_pile
    ref_pile ||= node.pile.owner.piles.new
  end
  
end
