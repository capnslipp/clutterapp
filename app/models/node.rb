class Node < ActiveRecord::Base
  acts_as_nested_set :scope => :pile, :dependent => :destroy
  
  belongs_to :prop, :polymorphic => true, :autosave => true, :validate => true, :dependent => :destroy
  
  belongs_to :pile
  before_validation_on_create :assign_pile
  
  
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
  
  
  def short_name
      prop_type = read_attribute(:prop_type)
      prop_type.classify.short_name unless prop_type.nil?
  end
  
  def <=>(other)
    self.prop <=> other.prop
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
    self.prop = Prop.class_from_type(
      params.delete('prop_type')
    ).new(params)
  end
  
  
  def self_and_non_badgeable_siblings
    nested_set_scope.scoped :conditions => { parent_column_name => parent_id, :prop_type => Prop.non_badgeable_types.collect(&:to_s) }
  end
  
  def non_badgeable_siblings
    without_self self_and_non_badgeable_siblings
  end
  
  def left_non_badgeable_sibling
    non_badgeable_siblings.find(:first, :conditions => ["#{self.class.quoted_table_name}.#{quoted_left_column_name} < ?", left],
      :order => "#{self.class.quoted_table_name}.#{quoted_left_column_name} DESC")
  end
  
  def right_non_badgeable_sibling
    non_badgeable_siblings.find(:first, :conditions => ["#{self.class.quoted_table_name}.#{quoted_left_column_name} > ?", left])
  end
  
  
  Prop.badgeable_types.each do |type|
    type_name = type.short_name.underscore
    
    if !type.stackable? # singular versions
      class_eval(<<-EOS, __FILE__, __LINE__)
        def #{type_name}_badge?
          self.children.typed(:#{type_name}).count > 0
        end
        
        def #{type_name}_badge
          self.children.typed(:#{type_name}).first
        end
      EOS
      
    else # plural versions
      class_eval(<<-EOS, __FILE__, __LINE__)
        def #{type_name}_badges?
          self.children.typed(:#{type_name}).count > 0
        end
        
        def #{type_name}_badges
          self.children.typed(:#{type_name})
        end
      EOS
    end
  end
  
  
protected
  
  def validate
    #errors.add(:node, "either be root and have pile; or it must be neither root ") if root? ^ (pile.root_node != self) # causes stack overflow
    errors.add(:node, "must have a prop or be root, not both") if root? && prop
    errors.add(:node, "must have either a prop or be root") if !root? && !prop
  end
  
  def assign_pile
    return if self.pile
    self.pile = parent.pile if parent
  end
  
end
