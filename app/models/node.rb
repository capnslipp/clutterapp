class Node < ActiveRecord::Base
  acts_as_nested_set
  
  belongs_to :prop, :polymorphic => true
  
  has_one :pile, :foreign_key => 'root_node_id'
  
  
  def validate
    unless in_limbo?
      errors.add(:pile, "must exist and #{self.class.to_s} must be root or neither") unless !pile.blank? ^ root? == false
      errors.add(:prop, "must exist or #{self.class.to_s} must be root but not both") unless !prop.blank? ^ root?
    end
  end
  
  
  #def initialize(prop)
  #  if prop.instance_of? Class && prop.superclass == Prop
  #    self.prop = 
  #  end
  #end
  
  
  #def prop
  #  read_attribute(:prop)
  #end
  #
  #def prop=(prop)
  #  write_attribute(:length, prop)
  #end
  
  
  def create_child!(*attributes)
    child = self.class.new(*attributes)
    child.send :put_in_limbo # magic hack to allow us to save the child; will be turned off by move_to()
    child.save!
    child.move_to_child_of(self)
    child
  end
  
  
  def self.rand
    self.build :prop => Prop.rand
  end
  
  def self.create_rand_in_pile(pile)
    pile.root_node.self_and_descendants.rand.create_child!(:prop => Prop.rand)
  end
  
  
  ## the purpose of in_limbo is to turn off validations that check that the node is parented or is a root node
  def in_limbo?
    !!(@in_limbo ||= false)
  end
  
  
  def move_to_with_limbo_check(*args)
    move_to_without_limbo_check(*args)
    @in_limbo = false
  end
  alias_method_chain :move_to, :limbo_check
  
  
protected
  
  def put_in_limbo
    @in_limbo = true
  end
  
end
