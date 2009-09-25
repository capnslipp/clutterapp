class Node < ActiveRecord::Base
  acts_as_nested_set :scope => :pile
  
  # must be specified first (at least before any associations)
  after_save :increment_version
  before_move :increment_parent_version
  after_move :increment_version
  
  belongs_to :prop, :polymorphic => true, :autosave => true
  
  belongs_to :pile
  
  
  def create_child!(*attributes)
    transaction do
      child = self.class.new(*attributes)
      child.save_with_validation false
      child.move_to_child_of self
      self.increment_version
      raise ActiveRecord::RecordInvalid.new(child) unless child.valid?
      child
    end
  end
  
  
  def self::rand
    self::new :prop => Prop.rand
  end
  
  def create_rand_child
    create_child!(:prop => Prop.rand)
  end
  
  def create_rand_descendant
    self_and_descendants.rand.create_rand_child
  end
  
  
  def after_prop_save
    increment_version
  end
  
  def after_child_destroy
    increment_version
  end
  
  
protected
  
  def validate
    errors.add('', "If this #{self.class.to_s} is root, it must exist have a Pile pointing back to it and vice-versa.") unless not (root? ^ !pile.nil?)
    errors.add(:prop, "must exist or #{self.class.to_s} must be root but not both") unless root? ^ !prop.nil?
  end
  
  def increment_version
    Node::increment_counter(:version, self.id)
    increment_parent_version
  end
  
  def increment_parent_version
    parent.increment_version unless parent.nil?
  end
  
end
