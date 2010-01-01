class ItemNode < Node
  belongs_to :prop, :polymorphic => true, :autosave => true, :validate => true
  
  before_validation_on_create :assign_pile
  
  
  accepts_nested_attributes_for :prop, :allow_destroy => true
  
  
  def variant
    self.prop.variant
  end
  def variant_name
    self.prop.variant_name
  end
  
  def <=>(other)
    if other.instance_of?(ItemNode)
      self.prop <=> other.prop
    else
      super(other)
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
    self.prop = Prop.derive_variant(
      params.delete('variant_name')
    ).new(params)
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
  
  
protected
  
  def validate
    errors.add(:node, "must not be root") if root?
    errors.add(:node, "must have a prop") unless prop
  end
  
  def assign_pile
    return if self.pile
    self.pile = parent.pile if parent
  end
  
end
