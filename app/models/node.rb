class Node < ActiveRecord::Base
  acts_as_nested_set
  
  belongs_to :prop, :polymorphic => true
  
  has_one :pile, :foreign_key => 'root_node_id'
  
  
  def create_child!(*attributes)
    transaction do
      child = self.class.new(*attributes)
      child.save_with_validation(false)
      child.move_to_child_of(self)
      raise ActiveRecord::RecordInvalid.new(child) unless child.valid?
      child
    end
  end
  
  
  def self.rand
    self.build :prop => Prop.rand
  end
  
  def create_rand_child
    create_child!(:prop => Prop.rand)
  end
  
  def create_rand_descendant
    self.self_and_descendants.rand.create_rand_child
  end
  
  
protected
  
  def validate
    errors.add('', "If this #{self.class.to_s} is root, it must exist have a Pile pointing back to it and vice-versa.") unless root? ^ !pile.nil? == false
    errors.add(:prop, "must exist or #{self.class.to_s} must be root but not both") unless root? ^ !prop.nil?
  end
  
end
