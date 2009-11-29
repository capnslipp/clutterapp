class Node < ActiveRecord::Base
  acts_as_nested_set :scope => :pile, :dependent => :destroy
  
  attr_delta :version
  
  # must be specified first (at least before any associations)
  #before_update :increment_version
  #before_move :increment_parent_version
  #after_move :increment_version # necessary?
  
  belongs_to :prop, :polymorphic => true, :autosave => true
  
  belongs_to :pile
  
  
  #attr_accessible :node, :node_attributes, :prop, :prop_attributes, :children, :children_attributes
  accepts_nested_attributes_for :prop, :allow_destroy => true
  accepts_nested_attributes_for :children, :allow_destroy => true
  
  
  named_scope :typed, lambda {|type|
    { :conditions => {:prop_type => Prop.class_from_type(type).to_s} }
  }
  
  named_scope :badgeable,     :conditions => {:prop_type => Prop.badgeable_types.collect(&:to_s)}
  named_scope :non_badgeable, :conditions => {:prop_type => Prop.non_badgeable_types.collect(&:to_s)}
  
  named_scope :stackable,     :conditions => {:prop_type => Prop.stackable_types.collect(&:to_s)}
  named_scope :non_stackable, :conditions => {:prop_type => Prop.non_stackable_types.collect(&:to_s)}
  
  named_scope :nodeable,      :conditions => {:prop_type => Prop.nodeable_types.collect(&:to_s)}
  named_scope :non_nodeable,  :conditions => {:prop_type => Prop.non_nodeable_types.collect(&:to_s)}
  
  named_scope :deepable,      :conditions => {:prop_type => Prop.deepable_types.collect(&:to_s)}
  named_scope :non_deepable,  :conditions => {:prop_type => Prop.non_deepable_types.collect(&:to_s)}
  
  
  def to_s(format = :default, &block)
    if format == :short
      prop_type = read_attribute(:prop_type)
      prop_type.classify.short_name unless prop_type.nil?
    else
      super(&block)
    end
  end
  
  
  def self::rand_new
    self.new :prop => Prop.rand
  end
  
  def create_rand_child
    self.chilren.create!(:prop => Prop.rand)
  end
  
  
  def create_rand_descendant
    self_and_descendants.rand.create_rand_child
  end
  
  
  def build_prop(params)
    logger.prefixed 'Node#build_prop', :light_red, "params: #{params.inspect}"
    
    self.prop = Prop.class_from_type(
      params.delete(:type) || params.delete('type')
    ).new(params)
  end
  
  
  def before_prop_save
    increment_version
  end
  
  def after_child_destroy
    increment_version!
  end
  
  
protected
  
  def validate
    #errors.add(:node, "either be root and have pile; or it must be neither root ") if root? ^ (pile.root_node != self) # causes stack overflow
    errors.add(:node, "must have a prop or be root, not both") if root? && prop
    errors.add(:node, "must have either a prop or be root") if !root? && !prop
  end
  
  def increment_version
    version_delta = 1
    increment_parent_version
  end
  
  def increment_version!
    increment_version
    save!
  end
  
  def increment_parent_version
    parent.increment_version unless parent.nil?
  end
  
end
