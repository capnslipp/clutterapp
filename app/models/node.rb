class Node < ActiveRecord::Base
  acts_as_nested_set :scope => :pile, :dependent => :destroy
  
  # must be specified first (at least before any associations)
  after_save :increment_version
  before_move :increment_parent_version
  after_move :increment_version
  
  belongs_to :prop, :polymorphic => true, :autosave => true
  accepts_nested_attributes_for :prop
  
  belongs_to :pile
  
  
  named_scope :typed, lambda {|type|
    { :conditions => {:prop_type => Prop.class_from_type(type).to_s} }
  }
  
  named_scope :badgeable, lambda {|for_ability| badgeable_conditions(for_ability) }
  named_scope :stackable, lambda {|for_ability| stackable_conditions(for_ability) }
  named_scope :nodeable,  lambda {|for_ability| nodeable_conditions(for_ability) }
  
  
  def to_s(format = :default, &block)
    if format == :short
      prop_type = read_attribute(:prop_type)
      prop_type.classify.to_s(:short) unless prop_type.nil?
    else
      super(&block)
    end
  end
  
  
  def create_child!(*attributes)
    transaction do
      child = pile.nodes.build(*attributes)
      child.save_with_validation false
      child.move_to_child_of self
      self.increment_version
      raise ActiveRecord::RecordInvalid.new(child) unless child.valid?
      child
    end
  end
  
  
  def self::rand_new
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
    #errors.add(:node, "either be root and have pile; or it must be neither root ") if root? ^ (pile.root_node != self) # causes stack overflow
    errors.add(:prop, "must exist or #{self.class.to_s} must be root but not both") unless root? ^ prop
  end
  
  def increment_version
    Node::increment_counter(:version, self.id)
    increment_parent_version
  end
  
  def increment_parent_version
    parent.increment_version unless parent.nil?
  end
  
  def self::badgeable_conditions(for_ability)
    if for_ability
      { :conditions => {:prop_type => Prop.badgeable_types.collect(&:to_s)} }
    else
      { :conditions => {:prop_type => (Prop.types - Prop.badgeable_types).collect(&:to_s)} }
    end
  end
  
  def self::stackable_conditions(for_ability)
    if for_ability
      { :conditions => {:prop_type => Prop.stackable_types.collect(&:to_s)} }
    else
      { :conditions => {:prop_type => (Prop.types - Prop.stackable_types).collect(&:to_s)} }
    end
  end
  
  def self::nodeable_conditions(for_ability)
    if for_ability
      { :conditions => {:prop_type => Prop.nodeable_types.collect(&:to_s)} }
    else
      { :conditions => {:prop_type => (Prop.types - Prop.nodeable_types).collect(&:to_s)} }
    end
  end
  
end
