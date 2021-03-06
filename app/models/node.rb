class Node < ActiveRecord::Base
  acts_as_nested_set :scope => :pile, :dependent => :destroy
  
  accepts_nested_attributes_for :children, :allow_destroy => true
  
  belongs_to :prop, :polymorphic => true, :autosave => true, :validate => true, :dependent => :destroy
  accepts_nested_attributes_for :prop, :allow_destroy => true
  
  belongs_to :pile, :inverse_of => :nodes
  before_validation_on_create :assign_children_parent
  before_validation_on_create :assign_pile
  validates_presence_of :pile
  
  
  named_scope :varianted, lambda {|variant_or_name|
    { :conditions => {:prop_type => Prop.derive_variant(variant_or_name).to_s} }
  }
  
  named_scope :badgeable,     :conditions => {:prop_type => Prop.badgeable_variants.collect(&:to_s)}
  named_scope :non_badgeable, :conditions => {:prop_type => Prop.non_badgeable_variants.collect(&:to_s)}
  
  named_scope :stackable,     :conditions => {:prop_type => Prop.stackable_variants.collect(&:to_s)}
  named_scope :non_stackable, :conditions => {:prop_type => Prop.non_stackable_variants.collect(&:to_s)}
  
  named_scope :nodeable,      :conditions => {:prop_type => Prop.nodeable_variants.collect(&:to_s)}
  named_scope :non_nodeable,  :conditions => {:prop_type => Prop.non_nodeable_variants.collect(&:to_s)}
  
  named_scope :deepable,      :conditions => {:prop_type => Prop.deepable_variants.collect(&:to_s)}
  named_scope :non_deepable,  :conditions => {:prop_type => Prop.non_deepable_variants.collect(&:to_s)}
  
  
  def variant
    self.prop.variant
  end
  def variant_name
    self.prop.variant_name
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
  
  
  def build_prop(attrs = {})
    self.prop = Prop.derive_variant(
      attrs.delete('variant_name')
    ).new(attrs)
  end
  
  
  def self_and_non_badgeable_siblings
    nested_set_scope.scoped :conditions => { parent_column_name => parent_id, :prop_type => Prop.non_badgeable_variants.collect(&:to_s) }
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
  
  
  Prop.badgeable_variants.each do |variant|
    variant_name = variant.short_name
    
    if !variant.stackable? # singular versions
      class_eval(<<-EOS, __FILE__, __LINE__)
        def #{variant_name}_badge?
          self.children.varianted(#{variant}).count > 0
        end
        
        def #{variant_name}_badge
          self.children.varianted(#{variant}).first
        end
      EOS
      
    else # plural versions
      class_eval(<<-EOS, __FILE__, __LINE__)
        def #{variant_name}_badges?
          self.children.varianted(#{variant}).count > 0
        end
        
        def #{variant_name}_badges
          self.children.varianted(#{variant})
        end
      EOS
    end
  end
  
  begin # Node Ordering Compatibility Utilities
    
    # accepts the typical array of ids from a scriptaculous sortable. It is called on the instance being moved
    def sort(array_of_ids)
      if array_of_ids.first == id.to_s
        move_to_left_of siblings.find(array_of_ids.second)
      else
        move_to_right_of siblings.find(array_of_ids[array_of_ids.index(id.to_s) - 1])
      end
    end
    
  end
  
  
protected
  
  def validate
    if parent.nil?
      errors.add(:node, "must not have a prop (when parent-less)") if prop
    else
      errors.add(:node, "must have a prop (when having a parent)") unless prop
    end
  end
  
  def assign_children_parent
    children.each do |c|
      next if c.parent_id && c.parent_id == self.id
      c.parent = self
    end
  end
  
  def assign_pile
    self.pile = parent.pile if parent
  end
  
end
