class PileRefProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node, :on => :update # less stringent when the Prop is new in order to prevent circular dependencies
  
  belongs_to :ref_pile, :class_name => Pile.name, :autosave => true, :validate => true, :dependent => :destroy
  validates_presence_of :ref_pile
  accepts_nested_attributes_for :ref_pile, :allow_destroy => true
  prop_value_field :ref_pile
  # @note: be sure to set the ref_pile to point to a Pile!
  
  
  is_stackable
  isnt_deepable
  
  
  #def self::rand_new
  #end
  
  def self::filler_new
    new :ref_pile => Pile.new
  end
  
end
